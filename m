Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:55154 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbbLDNrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 08:47:39 -0500
Subject: Re: Dear TV card experts - I need you help
To: Mr Andersson <mr.andersson.001@gmail.com>,
	linux-media@vger.kernel.org
References: <CAAhQ-nCBFCZhNxdB-Tp0E=cX9BOgAh9qApPaFKruvJSASxL5_w@mail.gmail.com>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <56619977.8070905@southpole.se>
Date: Fri, 4 Dec 2015 14:47:35 +0100
MIME-Version: 1.0
In-Reply-To: <CAAhQ-nCBFCZhNxdB-Tp0E=cX9BOgAh9qApPaFKruvJSASxL5_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2015 02:45 PM, Mr Andersson wrote:
> Hi,
>
[,,,]
>
> Most cards out there supports maximum 4 channels per cards. Some I've
> looked into costs around 200 USD per card and for 2000 channels,
> excluding all other hardware, that would cost around 100 000 USD.
>
[...]

The terminology you are looking for is 4 muxes per card, not channel. 
One mux can hold several channels. One satellite I looked at had ca 24
fta muxes with ca 3-4 channels per mux. So to cover this whole satellite 
you would need 6 quad cards. If a quad card costs $200 that gives you 
$50 / mux cost. The cheapest single mux s2 card I could find cost ca 
$60. So $50/mux is probably what you have to pay for this component if 
you buy from a reseller.

MvH
Benjamin Larsson
