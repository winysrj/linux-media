Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab0GSWm2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 18:42:28 -0400
Message-ID: <4C44D5AA.8060600@redhat.com>
Date: Tue, 20 Jul 2010 00:46:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yuri <yuri@rawbw.com>
CC: linux-media@vger.kernel.org
Subject: Re: Bugreport for libv4l: error out on webcam: error parsing JPEG
 header: Bogus jpeg format
References: <4C3F61BD.7000001@rawbw.com> <4C444388.9040901@redhat.com> <4C448311.6090704@rawbw.com>
In-Reply-To: <4C448311.6090704@rawbw.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/19/2010 06:53 PM, Yuri wrote:
> On 07/19/2010 05:22, Hans de Goede wrote:
>> This is not really a bug in libv4l, but more of a problem with error
>> tolerance in the application you are using. However many apps don't
>> handle
>> any kind of errors all that well. So the latest libv4l will retry (get
>> a new
>> frame) jpeg decompression errors a number of times.
>
> You are right, application is quite rough and doesn't have any tolerance.
>
> But why such bad bytes appear in the first place? I think they are sent
> by the
> camera deliberately to indicate something and Windows driver must be
> knowing
> what do they mean.

That is not very likely as they are in the middle of the jpeg data stream
(special bytes would normally be in the header or footer of each frame).

Most likely the cause is a not 100% usb connection, or some subtle linux
driver bug causing this.

Regards,

Hans
