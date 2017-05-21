Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38137 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756876AbdEUUJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:09:59 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 02/16] ALSA: Update document about copy_silence PCM ops
Date: Sun, 21 May 2017 22:09:36 +0200
Message-Id: <20170521200950.4592-3-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 .../sound/kernel-api/writing-an-alsa-driver.rst    | 110 ++++++++++++---------
 1 file changed, 63 insertions(+), 47 deletions(-)

diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
index 95c5443eff38..ebaf8b1e0079 100644
--- a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
+++ b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
@@ -2080,18 +2080,18 @@ sleeping poll threads, etc.
 
 This callback is also atomic as default.
 
-copy and silence callbacks
-~~~~~~~~~~~~~~~~~~~~~~~~~~
+copy_silence callback
+~~~~~~~~~~~~~~~~~~~~~
 
-These callbacks are not mandatory, and can be omitted in most cases.
-These callbacks are used when the hardware buffer cannot be in the
+This callback is not mandatory, and can be omitted in most cases.
+This callback is used when the hardware buffer cannot be in the
 normal memory space. Some chips have their own buffer on the hardware
 which is not mappable. In such a case, you have to transfer the data
 manually from the memory buffer to the hardware buffer. Or, if the
 buffer is non-contiguous on both physical and virtual memory spaces,
 these callbacks must be defined, too.
 
-If these two callbacks are defined, copy and set-silence operations
+If this callback is defined, copy and set-silence operations
 are done by them. The detailed will be described in the later section
 `Buffer and Memory Management`_.
 
@@ -3545,30 +3545,34 @@ Another case is when the chip uses a PCI memory-map region for the
 buffer instead of the host memory. In this case, mmap is available only
 on certain architectures like the Intel one. In non-mmap mode, the data
 cannot be transferred as in the normal way. Thus you need to define the
-``copy`` and ``silence`` callbacks as well, as in the cases above. The
+``copy_silence`` callback as well, as in the cases above. The
 examples are found in ``rme32.c`` and ``rme96.c``.
 
-The implementation of the ``copy`` and ``silence`` callbacks depends
+The implementation of the ``copy_silence`` callback depends
 upon whether the hardware supports interleaved or non-interleaved
-samples. The ``copy`` callback is defined like below, a bit
+samples. The ``copy_silence`` callback is defined like below, a bit
 differently depending whether the direction is playback or capture:
 
 ::
 
   static int playback_copy(struct snd_pcm_substream *substream, int channel,
-               snd_pcm_uframes_t pos, void *src, snd_pcm_uframes_t count);
+               snd_pcm_uframes_t pos, void __user *src,
+	       snd_pcm_uframes_t count, bool in_kernel);
   static int capture_copy(struct snd_pcm_substream *substream, int channel,
-               snd_pcm_uframes_t pos, void *dst, snd_pcm_uframes_t count);
+               snd_pcm_uframes_t pos, void __user *dst,
+	       snd_pcm_uframes_t count, bool in_kernel);
 
 In the case of interleaved samples, the second argument (``channel``) is
-not used. The third argument (``pos``) points the current position
-offset in frames.
+not used, and -1 is passed. The third argument (``pos``) points the
+current position offset in frames.
 
 The meaning of the fourth argument is different between playback and
 capture. For playback, it holds the source data pointer, and for
 capture, it's the destination data pointer.
 
-The last argument is the number of frames to be copied.
+The fifth argument is the number of frames to be copied.
+And the last argument indicates whether the passed buffer pointer is in
+user-space or in kernel-space.  The copy operation depends on this.
 
 What you have to do in this callback is again different between playback
 and capture directions. In the playback case, you copy the given amount
@@ -3578,52 +3582,64 @@ way, the copy would be like:
 
 ::
 
-  my_memcpy(my_buffer + frames_to_bytes(runtime, pos), src,
-            frames_to_bytes(runtime, count));
-
-For the capture direction, you copy the given amount of data (``count``)
-at the specified offset (``pos``) on the hardware buffer to the
-specified pointer (``dst``).
-
-::
+  if (!src)
+          my_memset(my_buffer + frames_to_bytes(runtime, pos), 0,
+                    frames_to_bytes(runtime, count));
+  else if (in_kernel)
+          memcpy_toio(my_buffer + frames_to_bytes(runtime, pos),
+                      (void *)src, frames_to_bytes(runtime, count));
+  else if (copy_from_user_toio(my_buffer + frames_to_bytes(runtime, pos),
+                               src, frames_to_bytes(runtime, count)))
+          return -EFAULT;
+  return 0;
 
-  my_memcpy(dst, my_buffer + frames_to_bytes(runtime, pos),
-            frames_to_bytes(runtime, count));
+Here we prepared three different memory operations operations.
 
-Note that both the position and the amount of data are given in frames.
+The first one, with the NULL ``src`` pointer, is for silencing the
+buffer. In this case, we clear the samples for the given position and
+portion.
 
-In the case of non-interleaved samples, the implementation will be a bit
-more complicated.
+The second one, with ``in_kernel`` check, is for the in-kernel memory
+copying.  In this case, the given buffer pointer (``src``) is a kernel
+pointer despite of being declared with ``__user`` prefix.  When this
+flag is set, you have to copy the memory from the kernel space.
+Typically, a simple :c:func:`memcpy()` or :c:func`memcpy_toio()` can
+be used.  Note the explicit cast at the function call there to drop
+``__user`` prefix.
 
-You need to check the channel argument, and if it's -1, copy the whole
-channels. Otherwise, you have to copy only the specified channel. Please
-check ``isa/gus/gus_pcm.c`` as an example.
+The last one is the usual operation, to copy from the user-space
+buffer to the hardware buffer.
 
-The ``silence`` callback is also implemented in a similar way
+For the capture direction, you copy the given amount of data (``count``)
+at the specified offset (``pos``) on the hardware buffer to the
+specified pointer (``dst``).
 
 ::
 
-  static int silence(struct snd_pcm_substream *substream, int channel,
-                     snd_pcm_uframes_t pos, snd_pcm_uframes_t count);
-
-The meanings of arguments are the same as in the ``copy`` callback,
-although there is no ``src/dst`` argument. In the case of interleaved
-samples, the channel argument has no meaning, as well as on ``copy``
-callback.
+  if (in_kernel)
+          memcpy_fromio((void *)dst,
+	          my_buffer + frames_to_bytes(runtime, pos),
+                  frames_to_bytes(runtime, count));
+  else if (copy_to_user_fromio(dst,
+                  my_buffer + frames_to_bytes(runtime, pos),
+                  frames_to_bytes(runtime, count)))
+          return -EFAULT;
+  return 0;
 
-The role of ``silence`` callback is to set the given amount
-(``count``) of silence data at the specified offset (``pos``) on the
-hardware buffer. Suppose that the data format is signed (that is, the
-silent-data is 0), and the implementation using a memset-like function
-would be like: 
+A clear difference from the playback is that there is no silencing
+mode.  For the capture direction, ``dst`` is always non-NULL.
 
-::
+Other than that, the two memory operations are similar, but just in
+different direction.  And, note that both the position and the amount
+of data are given in frames.
 
-  my_memcpy(my_buffer + frames_to_bytes(runtime, pos), 0,
-            frames_to_bytes(runtime, count));
+In the case of non-interleaved samples, the implementation will be a bit
+more complicated.  First off, the operation depends on ``channel``
+argument.  When -1 is passed there, copy the whole channels.
+Otherwise, copy only the specified channel.
 
-In the case of non-interleaved samples, again, the implementation
-becomes a bit more complicated. See, for example, ``isa/gus/gus_pcm.c``.
+As an implementation example, please take a look at the code in
+``sound/isa/gus/gus_pcm.c``.
 
 Non-Contiguous Buffers
 ----------------------
-- 
2.13.0
