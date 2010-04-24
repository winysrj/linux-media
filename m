Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:58729 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0DXUCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 16:02:40 -0400
Received: by fg-out-1718.google.com with SMTP id 19so993169fgg.1
        for <linux-media@vger.kernel.org>; Sat, 24 Apr 2010 13:02:37 -0700 (PDT)
Message-ID: <4BD34E5A.40507@googlemail.com>
Date: Sat, 24 Apr 2010 22:02:34 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
References: <4BD2EACA.5040005@googlemail.com> <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.04.2010 19:13, Mike Isely wrote:
>
> Actually the support in the pvrusb2 driver was never really completed.
> But since I don't have a sample of the hardware here I went on ahead and
> merged what was there so that it could get exposure and the remaining
> problems sorted out.
>
>    -Mike
>

Hi!

Although you never really completed that support for the AV400 it runs 
pretty well once you've touched the cx25840 source. I'm using it for 
months now and it runs better than it did with Windows (I sometimes had 
troubles with audio there which led to an "out of sync" audio track).

I wrote the last mail, because I want to sort out why the cx25837 chip 
in my device is behaving differently than expected by the corresponding 
driver and to remove the need to patch the v4l sources manually.
Once I don't need to fear that the next system update breaks the device 
again (because cx25840.ko is overwritten), I'm more then willed to help 
you to complete the support for my device in your driver (feature 
testing, etc).

Regards,
Sven

PS: Did you read my mail from last December? 
http://www.isely.net/pipermail/pvrusb2/2009-December/002716.html
