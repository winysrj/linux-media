Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBKCkSui023381
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 07:46:28 -0500
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBKCkCjZ020132
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 07:46:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Sat, 20 Dec 2008 13:45:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812201345.56672.hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [REVIEW] v4l2 debugging: match drivers by name instead of the
	deprecated ID
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

Jean Delvare has stated repeatedly that the I2C driver IDs will have to go. 
However, one major user inside V4L2 are the VIDIOC_G_CHIP_IDENT and 
VIDIOC_DBG_G/S_REGISTER ioctls.

These ioctls are meant as debugging and testing ioctls and (in the case of 
G_CHIP_IDENT) for internal use in the kernel (e.g. a bridge driver that 
needs to know which I2C chip variant is present).

These ioctls should not be used in applications and luckily this is indeed 
the case. I scanned the major applications and did a google search and 
everything came up clean.

I made the following changes:

#define V4L2_CHIP_MATCH_HOST       0  /* Match against chip ID on host (0 
for the host) */
#define V4L2_CHIP_MATCH_I2C_DRIVER 1  /* Match against I2C driver name */
#define V4L2_CHIP_MATCH_I2C_ADDR   2  /* Match against I2C 7-bit address */

struct v4l2_match_info {
        __u32 type; /* Match type */
        union {
                __u32 addr;
                char name[32];
        };
} __attribute__ ((packed));

struct v4l2_register {
        struct v4l2_match_info match;
        __u64 reg;
        __u64 val;
} __attribute__ ((packed));

/* VIDIOC_DBG_G_CHIP_IDENT */
struct v4l2_chip_ident {
        struct v4l2_match_info match;
        __u32 ident;
        __u32 revision;
} __attribute__ ((packed));

So the match will now be done against either a chip address or a driver 
name.

I also added additional comments in videodev2.h, warning against ever using 
it in applications:

#if 1 /*KEEP*/
/* Experimental, meant for debugging, testing and internal use.
   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
   You must be root to use these ioctls. Never use these in applications! */
#define VIDIOC_DBG_S_REGISTER    _IOW('V', 79, struct v4l2_register)
#define VIDIOC_DBG_G_REGISTER   _IOWR('V', 80, struct v4l2_register)

/* Experimental, meant for debugging, testing and internal use.
   Never use this ioctl in applications! */
#define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct v4l2_chip_ident)
#endif

And VIDIOC_G_CHIP_IDENT was renamed to VIDIOC_DBG_G_CHIP_IDENT, again to 
clearly mark this as a debugging API.

All this is available in this tree:
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-drvid

Now, the main question I have is whether I should keep the old 
VIDIOC_G_CHIP_IDENT around for 2.6.29 with a big warning if someone tries 
to use it, or do we just change it since 1) it is marked experimental and 
for debugging purposes only, and 2) I cannot find a single application that 
uses it and even Google throws up only a handful of pages.

Another question I have is for the omap developers: is it used in any omap 
applications that I don't know about? I doubt it since the chip-ident 
header is internal to the kernel so that's another reason why this ioctl is 
very unlikely to be used in applications.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
