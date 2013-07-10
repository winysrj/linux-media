Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44189 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754733Ab3GJWNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 18:13:54 -0400
Message-ID: <51DDDDF7.1010005@iki.fi>
Date: Thu, 11 Jul 2013 01:19:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
References: <201306241054.11604.hverkuil@xs4all.nl> <201307041313.25318.hverkuil@xs4all.nl> <51D5D8C8.2030400@gmail.com> <27462886.lEP1apMFVe@avalon> <51D88318.70904@gmail.com>
In-Reply-To: <51D88318.70904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Laurent,

Sylwester Nawrocki wrote:
> Hi Laurent,
...
>> We need an ioctl to report additional information about media entities
>> (it's
>> been on my to-do list for wayyyyyyyyy too long). It could be used to
>> report
>> bus information as well.
>
> Yes, that sounds much more interesting than using just subdev name to
> sqeeze
> all the information in. Why we don't have such an ioctl yet anyway ? Were
> there some arguments against it, or its been just a low priority issue ?

I think it's just been left unaddressed until now since there have been 
even more important things to work on. :-) I'm all for that, btw.; 
associating bus information to the media device instead of entities was 
always a little odd (feel free to blame me, too...).

Perhaps we could steal some bytes from the union in struct 
media_entity_desc? :-)

-- 
Cheers,

Sakari Ailus
sakari.ailus@iki.fi
