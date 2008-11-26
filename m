Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Wed, 26 Nov 2008 08:33:45 +0100
References: <200811032103.36711.laurent.pinchart@skynet.be>
	<200811040709.29024.hverkuil@xs4all.nl>
	<200811260105.03177.laurent.pinchart@skynet.be>
In-Reply-To: <200811260105.03177.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811260833.45485.hverkuil@xs4all.nl>
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

On Wednesday 26 November 2008 01:05:02 Laurent Pinchart wrote:
> Hi Hans,
>
> On Tuesday 04 November 2008, Hans Verkuil wrote:
> > Hi Laurent,
> >
> > Can you also patch v4l2-common.c to add support for this new
> > control?
> >
> > Actually, it would be great if the other missing controls (e.g.
> > FOCUS controls) are also added.
>
> As I'd rather not have to respin the patch (doesn't seem easily
> handled by Mercurial once changes are pushed to the linuxtv.org
> tree), I'll try to reach a consensus on control names first.
>
> - Do you have a preference for auto control names (such as auto-hue
> or auto-gain) ? "Auto Hue" would make lots of controls start with
> "Auto", "Hue, Auto" might be better.

I think I prefer 'Hue, Automatic'. This will keep it close to the 'Hue' 
control and using the full word rather than the abbreviation 'Auto' is 
(I think) a bit better since these are user-visible strings.

> - What about the absolute/relative controls ? They are currently used
> in the UVC driver only, and called "Pan (Absolute)" for instance.
> Should I rename that to "Pan, Absolute" ?

Yes, I think 'Pan, Absolute' is consistent with 'Hue, Automatic'. The 
comma notation is also similar to what is commonly used in an index of 
a book, so people are used to it.

>
> - Are you ok with V4L2_CID_DO_WHITE_BALANCE being called "Do White
> Balance" ?

Yes.

> - How should deprecated controls be named ?

The user doesn't care whether a control is deprecated or not, so I don't 
think there should be any special about the name. It's really an 
internal thing.

> Regarding v4l2_ctrl_query_fill_std(), the UVC specification doesn't
> specify boundaries for most controls so I can't fill the required
> values.

How is that handled in practice? If you have an integer control without 
min-max values, then how can you present that to the user in a control 
panel? A simple 0-15 control can be represented by e.g. a slider, but 
not a 0-INT_MAX control.

If the min/max are completely unknown, then you can always fill in the 
INT_MIN and INT_MAX values.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
