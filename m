Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FGvtCs026182
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 12:57:55 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FGvjI1024300
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 12:57:45 -0400
Received: by rv-out-0506.google.com with SMTP id f6so576103rvb.51
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 09:57:44 -0700 (PDT)
Message-ID: <d9def9db0805150957y2551bb19taf751b275decf79e@mail.gmail.com>
Date: Thu, 15 May 2008 18:57:43 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Dean Anderson" <dean@sensoray.com>
In-Reply-To: <482C5812.9090903@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514205927.GA13134@kroah.com>
	<d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
	<20080515024141.GB21941@kroah.com>
	<Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
	<482C5812.9090903@sensoray.com>
Cc: video4linux-list@redhat.com, Greg KH <greg@kroah.com>,
	linux-usb@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
	linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
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

On 5/15/08, Dean Anderson <dean@sensoray.com> wrote:
>>
>> Virtually all apps (V4L1 & 2) can handle YUV and RGB colorspaces.
>> Certainly all the major ones do and all the major libraries as well.
>>
>> The problem is when the device only supports some vendor specific or
>> otherwise very uncommon format.  In that case not doing the conversion in
>> the kernel means the device won't work with any existing software without
>> patches.  In this case, while it's not "the right way", drivers often end
>> up including an in kernel conversion for pragmatic reasons.
>>
>> This was a problem with the bayer format, but now userspace support for
>> that format is more common.
>>
>
> I agree the conversions don't belong in a driver. For the record, the
> following are done in the 2255 hardware: V4L2_PIX_FMT_GREY and
> V4L2_PIX_FMT_YUV422P.
>
> Since planar YUV formats such as V4L2_PIX_FMT_YUV422P are still not that
> well supported, is it possible to keep at least one packed YUV
> format(V4L2_PIX_FMT_YUYV) in the driver?  If not, let me know.  I will
> strongly suggest that the hardware Engineers add YUY2 or YUYV on board
> in the DSP firmware.  Thanks, Dean
>

Maybe it's better to fix up the corresponding application? If someone
wants to get those devices work he already either has to upgrade his
system or compile it manually at the moment.
With libswscale it's just a few lines of code to convert the formats
with a decent performance.
Seems like the demand of conversions is also growing for the future.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
