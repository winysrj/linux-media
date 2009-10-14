Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36066 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZJNNbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 09:31:07 -0400
Received: by ewy4 with SMTP id 4so4414787ewy.37
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 06:30:30 -0700 (PDT)
Message-ID: <4AD5D271.8040400@gmail.com>
Date: Wed, 14 Oct 2009 10:30:25 -0300
From: Guilherme Longo <grlongo.ireland@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Looking for libv4l documentation!
References: <156a113e0910130955w428d536i7fc3ac8355293030@mail.gmail.com> <4AD5CFEF.40004@gmail.com>
In-Reply-To: <4AD5CFEF.40004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a little observation,

I am looking for this library because my webcan has a sn9c10x chipset 
and I can´t find how sn9c10x pixelformat is captured.

There are a huge list of pixelformats in v4l2 spec but there is just a 
reserved word for this format. They say it exist but I can´t find how it 
is captured.

If someone could tell me where to find such documentation, plz, it would 
be better than converting the pixelformat.

Great Regards
Guilherme Longo

Guilherme Longo escreveu:
> Hi, I been searching for a tutorial or a documentation for libv4l to 
> convert the pixelformat supported by my webcan but I can´t find any.
>
> I found a article saying that I only should open my device using 
> v4l_open(/dev/video0) instead of open(/dev/video0) and the lib should 
> do the conversion, but it sound a bit odd for me since I believe it 
> should need a more sofisticated threatment.
>
> Does anyone could point to me any reference to such a documentation??
>
> Great regards!
> Guilherme Longo
>
