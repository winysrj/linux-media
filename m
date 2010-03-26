Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0CZKwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 06:52:51 -0400
Message-ID: <4BAC91FC.2070008@redhat.com>
Date: Fri, 26 Mar 2010 07:52:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: fix ENUMSTD ioctl to report all supported standards
References: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> V4L2_STD_PAL, V4L2_STD_SECAM, and V4L2_STD_NTSC are not the only composite 
> standards. Currently, e.g., if a driver supports all of V4L2_STD_PAL_B, 
> V4L2_STD_PAL_B1 and V4L2_STD_PAL_G, the enumeration will report 
> V4L2_STD_PAL_BG and not the single standards, which can confuse 
> applications. Fix this by only clearing simple standards from the mask. 
> This, of course, will only work, if composite standards are listed before 
> simple ones in the standards array in v4l2-ioctl.c, which is currently 
> the case.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

The patch looks sane to me. Yet, as it assumes the the standards array will follow
an specific construction rule, please add a comment before the array with the rule.

I doubt we would have any new analog standard added there, but yet, someone might
have the bright idea of sending a patch to reorder it with some different logic as
a "cleanup"  patch.


-

PS.: For the others that also want to review this patch, assuming that all PAL and
SECAM formats are supported, after the patch, it will also enumerate the following
video standards:

PAL-B
PAL-B1
PAL-G
PAL-D
PAL-D1
PAL-K
SECAM-D
SECAM-K
SECAM-K1

While the code is short, the logic behind it is somewhat complex, as the routine
will return the i-th element of an array of video standards.

The better way to test if the logic is properly working is to run it from
userspace, playing with the supported standards.

To save people some time, I've enclosed a simple test program that
could be used for that purpose, that I used on my review.

Playing with STD define and see the diffs between the old and the new code is
as simple as:

$ gcc -Wall -o test_std test_std.c && ./test_std old >old && ./test_std >new && diff --unified=0 old new 

A similar procedure can be done to compare the diff between the code with all
standards and all but some standards.


---
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <linux/videodev2.h>

//#define STD V4L2_STD_ALL
#define STD V4L2_STD_ALL & (~V4L2_STD_PAL_D1)
//#define STD V4L2_STD_ALL & (~V4L2_STD_SECAM_LC)

int is_power_of_2(unsigned long n)
{
        return (n != 0 && ((n & (n - 1)) == 0));
}

struct std_descr {
        v4l2_std_id std;
        const char *descr;
};

static const struct std_descr standards[] = {
	{ V4L2_STD_NTSC, 	"NTSC"      },
	{ V4L2_STD_NTSC_M, 	"NTSC-M"    },
	{ V4L2_STD_NTSC_M_JP, 	"NTSC-M-JP" },
	{ V4L2_STD_NTSC_M_KR,	"NTSC-M-KR" },
	{ V4L2_STD_NTSC_443, 	"NTSC-443"  },
	{ V4L2_STD_PAL, 	"PAL"       },
	{ V4L2_STD_PAL_BG, 	"PAL-BG"    },
	{ V4L2_STD_PAL_B, 	"PAL-B"     },
	{ V4L2_STD_PAL_B1, 	"PAL-B1"    },
	{ V4L2_STD_PAL_G, 	"PAL-G"     },
	{ V4L2_STD_PAL_H, 	"PAL-H"     },
	{ V4L2_STD_PAL_I, 	"PAL-I"     },
	{ V4L2_STD_PAL_DK, 	"PAL-DK"    },
	{ V4L2_STD_PAL_D, 	"PAL-D"     },
	{ V4L2_STD_PAL_D1, 	"PAL-D1"    },
	{ V4L2_STD_PAL_K, 	"PAL-K"     },
	{ V4L2_STD_PAL_M, 	"PAL-M"     },
	{ V4L2_STD_PAL_N, 	"PAL-N"     },
	{ V4L2_STD_PAL_Nc, 	"PAL-Nc"    },
	{ V4L2_STD_PAL_60, 	"PAL-60"    },
	{ V4L2_STD_SECAM, 	"SECAM"     },
	{ V4L2_STD_SECAM_B, 	"SECAM-B"   },
	{ V4L2_STD_SECAM_G, 	"SECAM-G"   },
	{ V4L2_STD_SECAM_H, 	"SECAM-H"   },
	{ V4L2_STD_SECAM_DK, 	"SECAM-DK"  },
	{ V4L2_STD_SECAM_D, 	"SECAM-D"   },
	{ V4L2_STD_SECAM_K, 	"SECAM-K"   },
	{ V4L2_STD_SECAM_K1, 	"SECAM-K1"  },
	{ V4L2_STD_SECAM_L, 	"SECAM-L"   },
	{ V4L2_STD_SECAM_LC, 	"SECAM-Lc"  },
	{ 0, 			"Unknown"   }
};

const char *v4l2_norm_to_name(v4l2_std_id id)
{
	int i;

	for (i = 0; standards[i].std; i++)
		if (id == standards[i].std)
			break;
	return standards[i].descr;
}

int main(int argc, char *argv[])
{
	v4l2_std_id curr_id, id = STD;
	unsigned int i, j = 0;
	const char *descr = "";
	int old = 0;

	if (argc == 2 && !strcasecmp(argv[1],"old"))
		old = 1;

	printf ("%s code\n", old? "old":"new");

	{

		/* Use here the code on __video_do_ioctl for ENUMSTD */

		/* Return norm array in a canonical way */
		for (i = 0; id; i++) {
			/* last std value in the standards array is 0, so this
			   while always ends there since (id & 0) == 0. */
			while ((id & standards[j].std) != standards[j].std)
				j++;
			curr_id = standards[j].std;
			descr = standards[j].descr;
			j++;
			if (curr_id == 0)
				break;
if (old) {
			if (curr_id != V4L2_STD_PAL &&
			    curr_id != V4L2_STD_SECAM &&
			    curr_id != V4L2_STD_NTSC)
				id &= ~curr_id;
} else {
			if (is_power_of_2(curr_id))
				id &= ~curr_id;
}

			printf("%s\n", v4l2_norm_to_name(curr_id));
		}

	}

	return 0;
}
