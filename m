Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:43011 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0ICNsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Sep 2010 09:48:21 -0400
Message-ID: <4C80FCA1.7050309@iki.fi>
Date: Fri, 03 Sep 2010 16:48:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fernando Cassia <fcassia@gmail.com>
CC: Dagur Ammendrup <dagurp@gmail.com>,
	Joel Wiramu Pauling <joel@aenertia.net>,
	linux-media@vger.kernel.org
Subject: Re: Gigabyte 8300
References: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>	<AANLkTikg79zui71Xz8r-Lg3zut0jkSk-BGEpBpXfWz5Y@mail.gmail.com>	<AANLkTimc2TTQQogO8Q6ih6Bv3j_oOcVMux3cg-CJPGsw@mail.gmail.com>	<AANLkTim_mU7ayxjeE2HQz57UsPqHU46dPC3Ys600RJAD@mail.gmail.com> <AANLkTi=Lf2R8c51zYyjKc4Dh+S0KjOZmSH90zghOdOn1@mail.gmail.com>
In-Reply-To: <AANLkTi=Lf2R8c51zYyjKc4Dh+S0KjOZmSH90zghOdOn1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On 09/03/2010 02:42 PM, Fernando Cassia wrote:
> Just FYI there´s two parts on that string, the "vid" (vendor ID) and
> the "pid" (product id)
>
> Vendor ID "1b80" is listed at the usb device id database
> as "Afatech" although the product ID is not listed (although all the
> products on that section seem to be Digital TV tuners).
>
> http://www.linux-usb.org/usb.ids
>
>
> --------------
> 1b80  Afatech
> 	c810  MC810 [af9015]
> 	d393  DVB-T receiver [RTL2832U]
> 	d396  UB396-T [RTL2832U]
> 	d397  DVB-T receiver [RTL2832U]
> 	d398  DVB-T receiver [RTL2832U]
> 	d700  FM Radio SnapMusic Mobile 700 (FM700)
> 	e383  DVB-T UB383-T [af9015]
> 	e385  DVB-T UB385-T [af9015]
> 	e386  DVB-T UB385-T [af9015]
> 	e39a  DVB-T395U [af9015]
> 	e39b  DVB-T395U [af9015]
>
>
> Someone please correct me if Im wrong.

You are correct. Someone added this wrong name about year back. In my 
understanding it should be KWorld instead of Afatech. I am not even 100% 
if it is KWorld since that VID is seen very many designs...

IIRC it was me who added this to the dvb-usb-ids.h:
#define USB_VID_KWORLD_2			0x1b80


Antti
-- 
http://palosaari.fi/
