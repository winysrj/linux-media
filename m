Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 26 Nov 2008 01:05:02 +0100
References: <200811032103.36711.laurent.pinchart@skynet.be>
	<200811032147.04546.laurent.pinchart@skynet.be>
	<200811040709.29024.hverkuil@xs4all.nl>
In-Reply-To: <200811040709.29024.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811260105.03177.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, mchehab@redhat.com
Subject: Re: [PATCH 2/2] v4l2: Add camera privacy control.
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

Hi Hans,

On Tuesday 04 November 2008, Hans Verkuil wrote:
> Hi Laurent,
>
> Can you also patch v4l2-common.c to add support for this new control?
>
> Actually, it would be great if the other missing controls (e.g. FOCUS
> controls) are also added.

As I'd rather not have to respin the patch (doesn't seem easily handled by 
Mercurial once changes are pushed to the linuxtv.org tree), I'll try to reach 
a consensus on control names first.

- Do you have a preference for auto control names (such as auto-hue or 
auto-gain) ? "Auto Hue" would make lots of controls start with "Auto", "Hue, 
Auto" might be better.

- What about the absolute/relative controls ? They are currently used in the 
UVC driver only, and called "Pan (Absolute)" for instance. Should I rename 
that to "Pan, Absolute" ?

- Are you ok with V4L2_CID_DO_WHITE_BALANCE being called "Do White Balance" ?

- How should deprecated controls be named ?

Regarding v4l2_ctrl_query_fill_std(), the UVC specification doesn't specify 
boundaries for most controls so I can't fill the required values.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
