Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:47025 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3BZMJI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 07:09:08 -0500
Message-ID: <512C91BC.4010306@schinagl.nl>
Date: Tue, 26 Feb 2013 11:43:08 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Geert Hedde Bosman <geert.hedde.bosman@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Please update DVB-T frequency list 'dvb-t/nl-All'
References: <512BD285.9010802@gmail.com>
In-Reply-To: <512BD285.9010802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25-02-13 22:07, Geert Hedde Bosman wrote:
> Hello,
> in summer 2012 in the Netherlands major frequency changes took place 
> in DVB-t broadcast. Some new frequencies were added as well. Therefore 
> the frequency-file dvb/dvb-t/nl-All is no longer actual. Could someone 
> (i believe Cristoph P. is one of the maintainers) please update this 
> file? The website http://radio-tv-nederland.nl/ provides an up to date 
> frequency list.
> As an example: i had to add the following line to the file 'nl-All' to 
> get the FTA tv-stations in the north of the Netherlands as it was 
> missing:
> T 674000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE
I'll go over the list and update all the frequencies. For me in the 
south, the list seems to be still accurate ;)

Expect a patch + push today/tomorrow.
>
> regards
> GHB
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

