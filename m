Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@in.tum.de>) id 1KuUq4-00048K-OV
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 17:21:09 +0100
Date: Mon, 27 Oct 2008 17:25:10 +0100
From: Georg Acher <acher@in.tum.de>
To: linux-dvb@linuxtv.org
Message-ID: <20081027162509.GF9657@localhost>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<49033440.6090609@gmx.de>
	<3cc3561f0810270337h4c33dd80n9b779a8dc3c8f8ce@mail.gmail.com>
	<20081027140348.GE9657@localhost>
	<1225122896.3124.13.camel@palomino.walls.org>
	<3cc3561f0810270916y2f9e07c1v9b9f27823cead38@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3cc3561f0810270916y2f9e07c1v9b9f27823cead38@mail.gmail.com>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, Oct 27, 2008 at 04:16:01PM +0000, Morgan T=F8rvolt wrote:
 =

> I must say that if any low-end equipment acutally measures the SNR
> properly, I will be very surprised. To get this feature usually costs
> thousands of dollars. If anyone could point me to a low cost DVB
> receiver that actually does this right, I would very much like to
> know.

The datasheet of the "good old" STV0299 shows the C/N indicator before the
decoding chain (Viterbi, deinterleaver, ...).

-- =

         Georg Acher, acher@in.tum.de
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
