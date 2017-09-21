Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60523
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751687AbdIUPip (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:38:45 -0400
Date: Thu, 21 Sep 2017 12:38:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "=?UTF-8?B?0JHRg9C00Lgg0KA=?= =?UTF-8?B?0L7QvNCw0L3RgtC+LA==?= AreMa Inc"
        <knightrider@are.ma>
Subject: Re: [PATCH 03/25] media: dvbdev: convert DVB device types into an
 enum
Message-ID: <20170921123836.5f4804af@recife.lan>
In-Reply-To: <CAOcJUbyoW9D8cyngc1VFpLLwOCPPqpzfhYEZ3n+nYyaLux4Hug@mail.gmail.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
        <47fa1e847d761e20c8d5c88701523abf7730f00d.1505933919.git.mchehab@s-opensource.com>
        <CAOcJUbyoW9D8cyngc1VFpLLwOCPPqpzfhYEZ3n+nYyaLux4Hug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Sep 2017 09:06:54 -0400
Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:

> On Wed, Sep 20, 2017 at 3:11 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:

> > +enum dvb_device_type {
> > +       DVB_DEVICE_SEC,
> > +       DVB_DEVICE_FRONTEND,
> > +       DVB_DEVICE_DEMUX,
> > +       DVB_DEVICE_DVR,
> > +       DVB_DEVICE_CA,
> > +       DVB_DEVICE_NET,
> > +
> > +       DVB_DEVICE_VIDEO,
> > +       DVB_DEVICE_AUDIO,
> > +       DVB_DEVICE_OSD,
> > +};  
> 
> maybe instead:
> ```
> enum dvb_device_type {
>  DVB_DEVICE_SEC      = 0,
>  DVB_DEVICE_FRONTEND = 1,
>  DVB_DEVICE_DEMUX    = 2,
>  DVB_DEVICE_DVR      = 3,
>  DVB_DEVICE_CA       = 4,
>  DVB_DEVICE_NET      = 5,
> 
>  DVB_DEVICE_VIDEO    = 6,
>  DVB_DEVICE_AUDIO    = 7,
>  DVB_DEVICE_OSD      = 8,
> };
> ```
> 
> ...and then maybe `nums2minor()` can be optimized to take advantage of
> that assignment.

That will break userspace :-) The DVB minor ranges are
(from Documentation/drivers.txt):

 212 char	LinuxTV.org DVB driver subsystem
		  0 = /dev/dvb/adapter0/video0    first video decoder of first c
ard
		  1 = /dev/dvb/adapter0/audio0    first audio decoder of first c
ard
		  2 = /dev/dvb/adapter0/sec0      (obsolete/unused)
		  3 = /dev/dvb/adapter0/frontend0 first frontend device of first
 card
		  4 = /dev/dvb/adapter0/demux0    first demux device of first ca
rd
		  5 = /dev/dvb/adapter0/dvr0      first digital video recoder de
vice of first card
		  6 = /dev/dvb/adapter0/ca0       first common access port of fi
rst card
		  7 = /dev/dvb/adapter0/net0      first network device of first 
card
		  8 = /dev/dvb/adapter0/osd0      first on-screen-display device
 of first card

Btw, the main reason to add a switch at nums2minor() is due to that:
it requires an specific number for each device type, and it is very easy
to forget about that when looking at the implementation.

As some day we may get rid of video/audio/osd types, it sounded worth to 
add an extra code. Please notice, however, that nums2minor only exists
if !CONFIG_DVB_DYNAMIC_MINORS.

I suspect that, except for some embedded devices, the default is
to have it enabled everywhere.

Yet, after revisiting it and checking the generated assembly code,
I guess we could fold the enclosed patch, in order to simplify the
static minor support of the DVB core:


--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -68,22 +68,20 @@ static const char * const dnames[] = {
 #else
 #define DVB_MAX_IDS            4
 
-static int nums2minor(int num, enum dvb_device_type type, int id)
-{
-       int n = (num << 6) | (id << 4);
+static const u8 minor_type[] = {
+       [DVB_DEVICE_VIDEO]      = 0,
+       [DVB_DEVICE_AUDIO]      = 1,
+       [DVB_DEVICE_SEC]        = 2,
+       [DVB_DEVICE_FRONTEND]   = 3,
+       [DVB_DEVICE_DEMUX]      = 4,
+       [DVB_DEVICE_DVR]        = 5,
+       [DVB_DEVICE_CA]         = 6,
+       [DVB_DEVICE_NET]        = 7,
+       [DVB_DEVICE_OSD]        = 8,
+};
 
-       switch (type) {
-       case DVB_DEVICE_VIDEO:          return n;
-       case DVB_DEVICE_AUDIO:          return n | 1;
-       case DVB_DEVICE_SEC:            return n | 2;
-       case DVB_DEVICE_FRONTEND:       return n | 3;
-       case DVB_DEVICE_DEMUX:          return n | 4;
-       case DVB_DEVICE_DVR:            return n | 5;
-       case DVB_DEVICE_CA:             return n | 6;
-       case DVB_DEVICE_NET:            return n | 7;
-       case DVB_DEVICE_OSD:            return n | 8;
-       }
-}
+#define nums2minor(num, type, id) \
+       (((num) << 6) | ((id) << 4) | minor_type[type])
 
 #define MAX_DVB_MINORS         (DVB_MAX_ADAPTERS*64)
 #endif

With the above change, it seems that the code is likely only a few bytes
longer than the original code, and make it clearer about the
static minor numbering requirements.

The generated i386 asm code at the read only data segment is:

minor_type:
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	0
	.byte	1
	.byte	8

And at the code segment:

# drivers/media/dvb-core/dvbdev.c:511: 	minor = nums2minor(adap->num, type, id);
	.loc 1 511 0
	movl	-20(%ebp), %eax	# %sfp, adap
.LVL295:
	movl	(%eax), %eax	# adap_29(D)->num, adap_29(D)->num
.LVL296:
	movl	%eax, -24(%ebp)	# adap_29(D)->num, %sfp
	movl	%eax, %edx	# adap_29(D)->num, adap_29(D)->num
	movl	12(%ebp), %eax	# type, tmp265
	sall	$6, %edx	#, adap_29(D)->num
	movzbl	minor_type(%eax), %eax	# minor_type, tmp193
	orl	%eax, %edx	# tmp193, tmp194
	movl	-16(%ebp), %eax	# %sfp, tmp195
	movl	%edx, %edi	# tmp194, tmp194
	sall	$4, %eax	#, tmp195
	orl	%eax, %edi	# tmp195, tmp194

That seems good enough on my eyes.

Thanks,
Mauro
