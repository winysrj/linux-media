Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:39905 "EHLO
	smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbaGRVRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 17:17:10 -0400
Message-ID: <53C98ECA.1050407@grumpydevil.homelinux.org>
Date: Fri, 18 Jul 2014 23:16:58 +0200
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org><6E594BCC1018445BA338AAABB100405C@ci5fish><53C92FB6.40300@grumpydevil.homelinux.org><BAE402E8671443828B8815421BDD81CD@ci5fish><53C93FCB.6000302@grumpydevil.homelinux.org> <53C94AFF.5080207@grumpydevil.homelinux.org> <B7F8B540D6D44D08A40DBFA9508FA901@ci5fish>
In-Reply-To: <B7F8B540D6D44D08A40DBFA9508FA901@ci5fish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-07-14 19:13, René wrote:
> Had you a look to the linuxtv.org wiki page ?
> If not read 
> http://linuxtv.org/wiki/index.php/Linux4Media_cineS2_DVB-S2_Twin_Tuner 
> if this correspond to your device you are may be missing the firmware 
> file (bottom of the page)
>

The ngene and the ddbridge are both bridge drivers. Checking the driver 
source, the ngene driver needs the ngene fw, the ddbridge does not need 
any firmware.

I did find something to check, but i need daylight to do so, as i am 
checking to get extermal power to the cards.

Cheers


Rudy
