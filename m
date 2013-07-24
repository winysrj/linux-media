Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:46911 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3GXRV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 13:21:29 -0400
From: Krishna Kishore <krishna.kishore@sasken.com>
To: Chris Lee <updatelee@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: stv090x vs stv0900 support
Date: Wed, 24 Jul 2013 17:21:09 +0000
Message-ID: <7CC27E99F1636344B0AC7B73D5BB86DE1485FEE5@exgmbxfz01.sasken.com>
References: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
In-Reply-To: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My opinion is that, it is better to have only stv090x. Apart from minimizing the number of patches and ease of maintenance, it will avoid the confusion that I had When I started using prof 7500. I had to enable stv0900 and stb6100. I got confused on whether to enable stv0900 or to enable stv090x.



-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Chris Lee
Sent: Wednesday, July 24, 2013 10:09 PM
To: linux-media@vger.kernel.org
Subject: stv090x vs stv0900 support

Im looking for comments on these two modules, they overlap support for the same demods. stv0900 supporting stv0900 and stv090x supporting
stv0900 and stv0903. Ive flipped a few cards from one to the other and they function fine. In some ways stv090x is better suited. Its a pain supporting two modules that are written differently but do the same thing, a fix in one almost always means it has to be implemented in the other as well.

Im not necessarily suggesting dumping stv0900, but Id like to flip a few cards that I own over to stv090x just to standardize it. The Prof
7301 and Prof 7500.

Whats everyones thoughts on this? It will cut the number of patch''s in half when it comes to these demods. Ive got alot more coming lol :)

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
