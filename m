Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:44744 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbLJBGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 20:06:50 -0500
Subject: Re: Dear TV card experts - I need you help
To: Mr Andersson <mr.andersson.001@gmail.com>
References: <CAAhQ-nCBFCZhNxdB-Tp0E=cX9BOgAh9qApPaFKruvJSASxL5_w@mail.gmail.com>
 <56619977.8070905@southpole.se>
 <CAAhQ-nDeF28mrCgZfOn+gD1053vubzorjwYmrU-cTbUMmXfWyw@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <5668D027.401@southpole.se>
Date: Thu, 10 Dec 2015 02:06:47 +0100
MIME-Version: 1.0
In-Reply-To: <CAAhQ-nDeF28mrCgZfOn+gD1053vubzorjwYmrU-cTbUMmXfWyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/04/2015 05:35 PM, Mr Andersson wrote:
> Hi Benjamin,
>
> Thanks for your answer. Jag uppskattar din hjälp ;)
>
> So 50 USD per mux. And I could simultaneously record up to  4 channels
> per mux ? Is that satellite dependant?
>
> Could you give me an example of high quality/value cards I should look at first?
>
> Also, what linux software would be best to use together with these
> cards? I am looking initially at just streaming the content right of,
> although we might need to hook into the stream and manipulate it.
> Later, we'd also might be interested in recording the stream as well.
>
> Thanks!

Hi, the question you ask needs an answer in the form of basic digital tv 
tutorial. I suggest you search the web for that info.

Regarding software I suggest you look at the tvheadend project. It has a 
software model that is easy to understand.

Regarding hardware I would go for quad pcie in a form factor that would 
fit in rack-mounted servers. You need high density and that is the only 
way to get that. So I would say skip trying to find something cheap, get 
something that is reliable and maintainable.

MvH
Benjamin Larsson
