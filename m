Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:57916 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3GXV4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 17:56:33 -0400
Message-ID: <51F04D8E.5050208@schinagl.nl>
Date: Wed, 24 Jul 2013 23:56:30 +0200
From: Oliver Schinagl <oliver@schinagl.nl>
Reply-To: oliver+list@schinagl.nl
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Krishna Kishore <krishna.kishore@sasken.com>,
	Chris Lee <updatelee@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: stv090x vs stv0900 support
References: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com> <7CC27E99F1636344B0AC7B73D5BB86DE1485FEE5@exgmbxfz01.sasken.com> <51F01477.7050202@iki.fi>
In-Reply-To: <51F01477.7050202@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/13 19:52, Antti Palosaari wrote:
> On 07/24/2013 08:21 PM, Krishna Kishore wrote:
>> My opinion is that, it is better to have only stv090x. Apart from minimizing the number of patches and ease of maintenance, it will avoid the confusion that I had When I started using prof 7500. I had to enable stv0900 and stb6100. I got confused on whether to enable stv0900 or to enable stv090x.
>>
>>
>>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Chris Lee
>> Sent: Wednesday, July 24, 2013 10:09 PM
>> To: linux-media@vger.kernel.org
>> Subject: stv090x vs stv0900 support
>>
>> Im looking for comments on these two modules, they overlap support for the same demods. stv0900 supporting stv0900 and stv090x supporting
>> stv0900 and stv0903. Ive flipped a few cards from one to the other and they function fine. In some ways stv090x is better suited. Its a pain supporting two modules that are written differently but do the same thing, a fix in one almost always means it has to be implemented in the other as well.
>>
>> Im not necessarily suggesting dumping stv0900, but Id like to flip a few cards that I own over to stv090x just to standardize it. The Prof
>> 7301 and Prof 7500.
>>
>> Whats everyones thoughts on this? It will cut the number of patch''s in half when it comes to these demods. Ive got alot more coming lol :)
>>
>> Chris
>
>
> stv0900 is better separated from the tuner whilst stv090x has weird
> stv6110x_devctl structure. That's why I used stv0900 for anysee driver.
> I wonder is there something special supported by stv090x because normal
> tuner/demod callbacks are not enough.
That's probably for the ddbridge driver, while ours is pretty old (0.5) 
Ralph/oliver is working on 0.9 atm. 0.8.6 still uses the same structure 
i think.
>
> regards
> Antti
>

