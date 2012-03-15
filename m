Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37535 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031690Ab2COSlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 14:41:46 -0400
Received: by lbbgm6 with SMTP id gm6so1611669lbb.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 11:41:45 -0700 (PDT)
Message-ID: <4F6237E1.1050706@gmail.com>
Date: Thu, 15 Mar 2012 19:41:37 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
References: <1577059.kW45pXQ20M@jar7.dominio> <4F57B520.9070607@gmail.com> <4F60D934.7040006@gmail.com> <1554005.yI229plrDj@jar7.dominio>
In-Reply-To: <1554005.yI229plrDj@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose Alberto Reguero skrev 2012-03-15 13:29:
> On Miércoles, 14 de marzo de 2012 18:45:24 Roger Mårtensson escribió:
>> So the drivers is doing something except I don't get anything in
>> kaffeine until I restart the application.
>> Now and then I even have to restart kaffeine twice. Same as above.. I
>> see it reading but nothing happens.
>>
>> I seem to find some EPG data since it can tell me what programs should
>> be shown.
>
> No, I don't have this problem. The only problem I have is when the reception
> is not very good, the cam don't work.
> Perhaps is a kaffeine problem, or a cam specific problem.


Bummer... :)

I'll see if I can find another DVB-application to test. My CAM is a SMIT 
CONAX cam and it is proven to work and many have had success. I have 
another CAM I could test but earlier test in another DVB-C card didn't work.

Thanks for your work. Hopefully your patch will be included soon. :)

Other than my "problem" everything works as expected.

