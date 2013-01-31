Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41751 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3AaOAc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 09:00:32 -0500
Message-ID: <510A78D8.7030602@iki.fi>
Date: Thu, 31 Jan 2013 15:59:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andre Heider <a.heider@gmail.com>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: af9035 test needed!
References: <50F05C09.3010104@iki.fi> <CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
In-Reply-To: <CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/2013 03:04 PM, Andre Heider wrote:
> Hi,
>
> On Fri, Jan 11, 2013 at 7:38 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Could you test that (tda18218 & mxl5007t):
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tuner
>
> I got a 'TerraTec Cinergy T Stick Dual RC (rev. 2)', which is fixed by
> this series.
> Any chance to get this into 3.9 (I guess its too late for the USB
> VID/PID 'fix' for 3.8)?

Thank you for the report! There was someone else who reported it working 
too. Do you want to your name as tester for the changelog?

I just yesterday got that TerraTec device too and I am going to add dual 
tuner support. Also, for some reason IT9135 v2 devices are not working - 
only v1. That is one thing I should fix before merge that stuff.

regards
Antti

-- 
http://palosaari.fi/
