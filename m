Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:34153 "EHLO
	smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbaGRQ1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 12:27:54 -0400
Message-ID: <53C94AFF.5080207@grumpydevil.homelinux.org>
Date: Fri, 18 Jul 2014 18:27:43 +0200
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org><6E594BCC1018445BA338AAABB100405C@ci5fish> <53C92FB6.40300@grumpydevil.homelinux.org> <BAE402E8671443828B8815421BDD81CD@ci5fish> <53C93FCB.6000302@grumpydevil.homelinux.org>
In-Reply-To: <53C93FCB.6000302@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-07-14 17:39, Rudy Zijlstra wrote:
>
>
> On 18-07-14 17:01, René wrote:
>> To know which modules shall be detected, we need at least the make 
>> and model of the device.
>> If you can read the references on the chips on the board, it would be 
>> great ...
> I see. What would happen if I build a monolithic kernel with all DVB 
> modules included?
>
> I'll check if i can read the chip references...
>
It's a Digital Devices Cine S2

If i made no reading mistakes:
STV0900B
Lattice LFE3 - 17EA

The tuners are below soldered shielding with the text "Digital Devices 
Tuner 1" and "Digitial Devices Tuner 2". As i am not good in soldering, 
i prefer not to remove the shielding
