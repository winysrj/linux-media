Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42525 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751236AbdFAU7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 27/27] ALSA: doc: Update copy_user, copy_kernel and fill_silence PCM ops
Date: Thu,  1 Jun 2017 22:58:50 +0200
Message-Id: <20170601205850.24993-28-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 .../sound/kernel-api/writing-an-alsa-driver.rst    | 111 ++++++++++++++-------
 1 file changed, 76 insertions(+), 35 deletions(-)

diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
index 95c5443eff38..58ffa3f5bda7 100644
--- a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
+++ b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
@@ -2080,8 +2080,8 @@ sleeping poll threads, etc.
 
 This callback is also atomic as default.
 
-copy and silence callbacks
-~~~~~~~~~~~~~~~~~~~~~~~~~~
+copy_user, copy_kernel and fill_silence ops
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 These callbacks are not mandatory, and can be omitted in most cases.
 These callbacks are used when the hardware buffer cannot be in the
@@ -3532,8 +3532,9 @@ external hardware buffer in interrupts (or in tasklets, preferably).
 
 The first case works fine if the external hardware buffer is large
 enough. This method doesn't need any extra buffers and thus is more
-effective. You need to define the ``copy`` and ``silence`` callbacks
-for the data transfer. However, there is a drawback: it cannot be
+effective. You need to define the ``copy_user`` and ``copy_kernel``
+callbacks for the data transfer, in addition to ``fill_silence``
+callback for playback. However, there is a drawback: it cannot be
 mmapped. The examples are GUS's GF1 PCM or emu8000's wavetable PCM.
 
 The second case allows for mmap on the buffer, although you have to
@@ -3545,30 +3546,34 @@ Another case is when the chip uses a PCI memory-map region for the
 buffer instead of the host memory. In this case, mmap is available only
 on certain architectures like the Intel one. In non-mmap mode, the data
 cannot be transferred as in the normal way. Thus you need to define the
-``copy`` and ``silence`` callbacks as well, as in the cases above. The
-examples are found in ``rme32.c`` and ``rme96.c``.
+``copy_user``, ``copy_kernel`` and ``fill_silence`` callbacks as well,
+as in the cases above. The examples are found in ``rme32.c`` and
+``rme96.c``.
 
-The implementation of the ``copy`` and ``silence`` callbacks depends
-upon whether the hardware supports interleaved or non-interleaved
-samples. The ``copy`` callback is defined like below, a bit
-differently depending whether the direction is playback or capture:
+The implementation of the ``copy_user``, ``copy_kernel`` and
+``silence`` callbacks depends upon whether the hardware supports
+interleaved or non-interleaved samples. The ``copy_user`` callback is
+defined like below, a bit differently depending whether the direction
+is playback or capture:
 
 ::
 
-  static int playback_copy(struct snd_pcm_substream *substream, int channel,
-               snd_pcm_uframes_t pos, void *src, snd_pcm_uframes_t count);
-  static int capture_copy(struct snd_pcm_substream *substream, int channel,
-               snd_pcm_uframes_t pos, void *dst, snd_pcm_uframes_t count);
+  static int playback_copy_user(struct snd_pcm_substream *substream,
+               int channel, unsigned long pos,
+               void __user *src, unsigned long count);
+  static int capture_copy_user(struct snd_pcm_substream *substream,
+               int channel, unsigned long pos,
+               void __user *dst, unsigned long count);
 
 In the case of interleaved samples, the second argument (``channel``) is
 not used. The third argument (``pos``) points the current position
-offset in frames.
+offset in bytes.
 
 The meaning of the fourth argument is different between playback and
 capture. For playback, it holds the source data pointer, and for
 capture, it's the destination data pointer.
 
-The last argument is the number of frames to be copied.
+The last argument is the number of bytes to be copied.
 
 What you have to do in this callback is again different between playback
 and capture directions. In the playback case, you copy the given amount
@@ -3578,8 +3583,7 @@ way, the copy would be like:
 
 ::
 
-  my_memcpy(my_buffer + frames_to_bytes(runtime, pos), src,
-            frames_to_bytes(runtime, count));
+  my_memcpy_from_user(my_buffer + pos, src, count);
 
 For the capture direction, you copy the given amount of data (``count``)
 at the specified offset (``pos``) on the hardware buffer to the
@@ -3587,31 +3591,68 @@ specified pointer (``dst``).
 
 ::
 
-  my_memcpy(dst, my_buffer + frames_to_bytes(runtime, pos),
-            frames_to_bytes(runtime, count));
+  my_memcpy_to_user(dst, my_buffer + pos, count);
+
+Here the functions are named as ``from_user`` and ``to_user`` because
+it's the user-space buffer that is passed to these callbacks.  That
+is, the callback is supposed to copy from/to the user-space data
+directly to/from the hardware buffer.
 
-Note that both the position and the amount of data are given in frames.
+Careful readers might notice that these callbacks receive the
+arguments in bytes, not in frames like other callbacks.  It's because
+it would make coding easier like the examples above, and also it makes
+easier to unify both the interleaved and non-interleaved cases, as
+explained in the following.
 
 In the case of non-interleaved samples, the implementation will be a bit
-more complicated.
+more complicated.  The callback is called for each channel, passed by
+the second argument, so totally it's called for N-channels times per
+transfer.
+
+The meaning of other arguments are almost same as the interleaved
+case.  The callback is supposed to copy the data from/to the given
+user-space buffer, but only for the given channel.  For the detailed
+implementations, please check ``isa/gus/gus_pcm.c`` or
+"pci/rme9652/rme9652.c" as examples.
+
+The above callbacks are the copy from/to the user-space buffer.  There
+are some cases where we want copy from/to the kernel-space buffer
+instead.  In such a case, ``copy_kernel`` callback is called.  It'd
+look like:
+
+::
+
+  static int playback_copy_kernel(struct snd_pcm_substream *substream,
+               int channel, unsigned long pos,
+               void *src, unsigned long count);
+  static int capture_copy_kernel(struct snd_pcm_substream *substream,
+               int channel, unsigned long pos,
+               void *dst, unsigned long count);
+
+As found easily, the only difference is that the buffer pointer is
+without ``__user`` prefix; that is, a kernel-buffer pointer is passed
+in the fourth argument.  Correspondingly, the implementation would be
+a version without the user-copy, such as:
 
-You need to check the channel argument, and if it's -1, copy the whole
-channels. Otherwise, you have to copy only the specified channel. Please
-check ``isa/gus/gus_pcm.c`` as an example.
+::
+
+  my_memcpy(my_buffer + pos, src, count);
 
-The ``silence`` callback is also implemented in a similar way
+Usually for the playback, another callback ``fill_silence`` is
+defined.  It's implemented in a similar way as the copy callbacks
+above:
 
 ::
 
   static int silence(struct snd_pcm_substream *substream, int channel,
-                     snd_pcm_uframes_t pos, snd_pcm_uframes_t count);
+                     unsigned long pos, unsigned long count);
 
-The meanings of arguments are the same as in the ``copy`` callback,
-although there is no ``src/dst`` argument. In the case of interleaved
-samples, the channel argument has no meaning, as well as on ``copy``
-callback.
+The meanings of arguments are the same as in the ``copy_user`` and
+``copy_kernel`` callbacks, although there is no buffer pointer
+argument. In the case of interleaved samples, the channel argument has
+no meaning, as well as on ``copy_*`` callbacks.
 
-The role of ``silence`` callback is to set the given amount
+The role of ``fill_silence`` callback is to set the given amount
 (``count``) of silence data at the specified offset (``pos``) on the
 hardware buffer. Suppose that the data format is signed (that is, the
 silent-data is 0), and the implementation using a memset-like function
@@ -3619,11 +3660,11 @@ would be like:
 
 ::
 
-  my_memcpy(my_buffer + frames_to_bytes(runtime, pos), 0,
-            frames_to_bytes(runtime, count));
+  my_memset(my_buffer + pos, 0, count);
 
 In the case of non-interleaved samples, again, the implementation
-becomes a bit more complicated. See, for example, ``isa/gus/gus_pcm.c``.
+becomes a bit more complicated, as it's called N-times per transfer
+for each channel. See, for example, ``isa/gus/gus_pcm.c``.
 
 Non-Contiguous Buffers
 ----------------------
-- 
2.13.0
