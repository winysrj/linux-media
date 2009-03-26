Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2QGgmT7030176
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:42:48 -0400
Received: from mail11d.verio-web.com (mail11d.verio-web.com [204.202.242.86])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2QGgPiW001472
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:42:25 -0400
Received: from mx14.stngva01.us.mxservers.net (204.202.242.37)
	by mail11d.verio-web.com (RS ver 1.0.95vs) with SMTP id 0-0479965745
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:42:25 -0400 (EDT)
Message-ID: <49CBB06E.4070305@sensoray.com>
Date: Thu, 26 Mar 2009 09:42:22 -0700
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
References: <20090326160017.048668E03F1@hormel.redhat.com>
In-Reply-To: <20090326160017.048668E03F1@hormel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: hdegoede@redhat.com, video4linux-list@redhat.com, Greg KH <greg@kroah.com>
Subject: Re: Re: Skype and libv4
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

Hi, Please see comments below:

> Subject:
> Re: Skype and libv4
> From:
> Lamarque Vieira Souza <lamarque@gmail.com>
> Date:
> Thu, 26 Mar 2009 10:36:56 -0300
> To:
> Hans de Goede <hdegoede@redhat.com>
> 
> To:
> Hans de Goede <hdegoede@redhat.com>
> CC:
> video4linux-list@redhat.com
> 
> 
> 
> Em Thursday 26 March 2009, Hans de Goede escreveu:
>> Hi all,
>>
>> Not quite, the correct behaviour is:
>> "If the field value is set to an unsupported value, then set the field
>> value to *a* value that the driver accepts"
> 
> 	Now I get it. This webcam only accepts V4L2_FIELD_NONE, so commenting that 
> part of try_fmt makes it compliant with v4l2 standard. Thank you for helping 
> me with this. The zr364xx's maintainer contacted me yesterday, he is busy 
> theses days, when he has more time he is going to take a look at my changes. 
> With lucky the changes will be in 2.6.30. At least 2.6.29 sets the 
> compat_ioctl32 automatically for all drivers, in 2.6.28.8 I had to set it in 
> the driver to make Skype and mplayer (32-bit) work, one less change for the 
> driver :-)

The lack of V4L2_FIELD_NONE caused what sort of problems in these 
applications/drivers?  Did you the driver recover without it?

> 
>> This takes in to account certain devices can support multiple field types,
>> which is the whole purpose of the field value.
>>
>> And yes unfortunately many many v4l drivers have various bugs in their
>> implementation, in some cases I do work around driver bugs in libv4l, but
>> it this case that would hurt proper use of the field value, and that is not
>> acceptable, so fixing the driver is the only solution.

Can you elaborate on the V4L drivers with bugs?  If they aren't 
identified, they won't be fixed.

> 
> 	Have you tried to contact the drivers' maintainers for fixing those bugs?
> 
>> Note, that the v4l2 API is pretty well documented, and the correct
>> behaviour as I describe it can be found in the docs too:
>> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r10944.htm
>>
>> And the "Return Value" section, note how EINVAL is only supposed to be
>> returned up on an invalid, or unsupported type value. And also from the
>> description: "Drivers should not return an error code unless the input is
>> ambiguous"
> 
> 
> 
> ------------------------------------------------------------------------
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


I also have a question about the removal of videobuf_waiton in the 
patch.  Only 3 other drivers are using videobuf_waiton. Should 
videobuf_waiton be removed from them also?  I believe it was in vivi.c 
at some point, but I'll have to double check...




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
