Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1GBK1I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 06:27:08 -0400
Message-ID: <4E0EF2D3.8030109@redhat.com>
Date: Sat, 02 Jul 2011 12:28:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <201107011821.33960.hverkuil@xs4all.nl>
In-Reply-To: <201107011821.33960.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

<snip snip snip>

Ok, thinking about this some more and reading Hans V's comments
I think that the current code in Hans V's core8c branch is fine,
and should go to 3.1 (rather then be delayed to 3.2).

As for the fundamental question what to do with foo
controls when autofoo goes from auto to manual, as discussed
there are 2 options:
1) Restore the last known / previous manual setting
2) Keep foo at the current setting, iow the last setting
    configured by autofoo

Although it would be great if we could standardize on
one of these. I think that the answer here is to leave
this decision to the driver:
- In some cases this may not be under our control at all
   (ie with uvc devices),
-in other cases the hardware in question may make it
  impossible to read the setting as configured by autofoo,
  thus forcing scenario 1 so that we are sure the actual
  value for foo being used by the device matches what we
  report to the user once autofoo is in manual mode

That leaves Hans V's suggestion what to do with volatile
controls wrt reporting this to userspace. Hans V. suggested
splitting the control essentially in 2 controls, one r/w
with the manual value and a read only one with the volatile
value (*). I don't think this is a good idea, having 2
controls for one foo, will only clutter v4l2 control panels
or applets. I think we should try to keep the controls
we present to the user (and thus too userspace) to a minimum.

I suggest that instead of creating 2 controls, we add a
VOLATILE ctrl flag, which can then be set together with
the INACTIVE flag to indicate to a v4l2 control panel that
the value may change without it receiving change events. The
v4l2 control panel can then decide how it wants to deal with
this, ie poll to keep its display updated, ignore the flag,
...

Regards,

Hans


*) Either through a special flag signalling give me the
volatile value, or just outright making the 2 2 separate
controls.
