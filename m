Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57780 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3IEVoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 17:44:17 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so1186887eek.23
        for <linux-media@vger.kernel.org>; Thu, 05 Sep 2013 14:44:16 -0700 (PDT)
Message-ID: <5228FB2E.5050503@gmail.com>
Date: Thu, 05 Sep 2013 23:44:14 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC> multi-crop (was: Multiple Rectangle cropping)
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
In-Reply-To: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2013 11:10 PM, Ricardo Ribalda Delgado wrote:
> Hello

Hi,

>   I am working porting a industrial camera driver to v4l. So far I have
> been able to describe most of the old functionality with v4l
> equivalents. The only thing that I am missing is multi cropping.
>
> The sensor (both a cmosis and a ccd chips) supports skipping lines
> from up to 8 regions. This increases the readout speed up to 50%,
> which is critical for the application.
>
> Unfortunately I have no way to describe multiple cropping areas in
> v4l. I am thinking about creating a new API/extending and old one for
> this.
>
> Any suggestion before I start? Have you faced also this problem? How
> did you solve it?

A similar issue has been raised during discussions on the camera auto
focus rectangle selection API. While defining need selection targets [1]
it was also proposed to convert one of the struct v4l2_selection reserved
fields into an index field, which would indicate one rectangle of some
set of rectangles supported by a driver. Then there could be a v4l2
bitmask control to determine which rectangles are currently valid/in use.

Would something like this be relevant to your problem ?

> I am planning to go to the Edinburgh mini summit, maybe we could add
> this to the agenda (if you consider that it is worth the time, of
> course)

It definitely sounds like a good topic to discuss at the mini summit,
unless it gets resolved until then. ;-)

[1] http://www.spinics.net/lists/linux-media/msg64499.html

--
Regards,
Sylwester
