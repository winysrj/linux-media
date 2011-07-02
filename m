Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1932 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab1GBLKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 07:10:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Some comments on the new autocluster patches
Date: Sat, 2 Jul 2011 13:10:25 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E0DE283.2030107@redhat.com> <201107011821.33960.hverkuil@xs4all.nl> <4E0EF2D3.8030109@redhat.com>
In-Reply-To: <4E0EF2D3.8030109@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021310.25562.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, July 02, 2011 12:28:35 Hans de Goede wrote:
> Hi,
> 
> <snip snip snip>
> 
> Ok, thinking about this some more and reading Hans V's comments
> I think that the current code in Hans V's core8c branch is fine,
> and should go to 3.1 (rather then be delayed to 3.2).
> 
> As for the fundamental question what to do with foo
> controls when autofoo goes from auto to manual, as discussed
> there are 2 options:
> 1) Restore the last known / previous manual setting
> 2) Keep foo at the current setting, iow the last setting
>     configured by autofoo

Or option 3:

Just don't report the automatic foo values at all. What possible purpose
does it serve? It is my impression that drivers implement it 'just because
they can', and not because it is meaningful.

I'm not aware of any application that actually refreshes e.g. gain values
when autogain is on, so end-users never see it anyway.

Volatile makes a lot of sense for read-only controls, but for writable
controls I really don't see why you would want it.

> Although it would be great if we could standardize on
> one of these. I think that the answer here is to leave
> this decision to the driver:
> - In some cases this may not be under our control at all
>    (ie with uvc devices),
> -in other cases the hardware in question may make it
>   impossible to read the setting as configured by autofoo,
>   thus forcing scenario 1 so that we are sure the actual
>   value for foo being used by the device matches what we
>   report to the user once autofoo is in manual mode
> 
> That leaves Hans V's suggestion what to do with volatile
> controls wrt reporting this to userspace. Hans V. suggested
> splitting the control essentially in 2 controls, one r/w
> with the manual value and a read only one with the volatile
> value (*). I don't think this is a good idea, having 2
> controls for one foo, will only clutter v4l2 control panels
> or applets. I think we should try to keep the controls
> we present to the user (and thus too userspace) to a minimum.

I agree with that.

> I suggest that instead of creating 2 controls, we add a
> VOLATILE ctrl flag, which can then be set together with
> the INACTIVE flag to indicate to a v4l2 control panel that
> the value may change without it receiving change events. The
> v4l2 control panel can then decide how it wants to deal with
> this, ie poll to keep its display updated, ignore the flag,
> ...

A volatile flag is certainly useful for read-only controls.

But I think we should stop supporting volatile writable controls.

It makes no sense from the point of view of a user. You won't see such behavior
in TVs etc. either. In rare cases you might want to export it through the
subdev API as a separate control so that advanced applications can get hold of
that value.

Does anyone know why you would want volatile writable controls?

Regards,

	Hans

> 
> Regards,
> 
> Hans
> 
> 
> *) Either through a special flag signalling give me the
> volatile value, or just outright making the 2 2 separate
> controls.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
