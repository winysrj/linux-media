Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52947 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab2HBTtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 15:49:05 -0400
Message-ID: <501AD9A3.8050301@iki.fi>
Date: Thu, 02 Aug 2012 22:48:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: bjlockie@lockie.ca
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
References: <50186040.1050908@lockie.ca>    <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>    <5019EE10.1000207@lockie.ca>    <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>    <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>    <7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca>    <CAGoCfiyo_1e5iA4jZ=44=DqQFcPf3+pUFrQ1h=LHg=O-r_nPQA@mail.gmail.com> <dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
In-Reply-To: <dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2012 10:41 PM, bjlockie@lockie.ca wrote:
>
>> Heck, even for the 1250 there are eight or ten different versions, so
>> most users wouldn't even know the right one to choose.
>
> Do you mean boards that use different chips?
> I hate it when manufacturers do that (ie. with routers).

That happens quite often. Few weeks back someone sends mail saying he 
has got new version of Terratec Cinergy T Stick Dual RC. Old version 
uses Afatech AF9015 chips whilst new revision is ITE Technologies IT9135 
and USB ID is same. Those are quite different chips and having different 
drivers. In such cases it could be quite challenging to get it working 
as both drivers are thinking it is for me according to USB ID.

regards
Antti


-- 
http://palosaari.fi/
