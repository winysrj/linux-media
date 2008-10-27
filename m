Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@in.tum.de>) id 1KuSdI-0002mh-5b
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 14:59:49 +0100
Date: Mon, 27 Oct 2008 15:03:48 +0100
From: Georg Acher <acher@in.tum.de>
To: linux-dvb@linuxtv.org
Message-ID: <20081027140348.GE9657@localhost>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<49033440.6090609@gmx.de>
	<3cc3561f0810270337h4c33dd80n9b779a8dc3c8f8ce@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3cc3561f0810270337h4c33dd80n9b779a8dc3c8f8ce@mail.gmail.com>
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

On Mon, Oct 27, 2008 at 10:37:52AM +0000, Morgan T=F8rvolt wrote:
 =

> As I used to work with satellite signals on an earth station, and was
> responsible for the development of measurement techniques, I thought I
> should join in here for some hopefully revelaing info.
> =

> I am guessing here of course, but I believe that there is no real SNR
> measurement in any of the tuners available for computers. =


My guess is that it is possible. Actually, it is quite easy for QPSK ;-) You
only need to calculate the distance of the IQ-value from the ideal symbol
center ( (sqrt(0.5),sqrt(0.5)) or whatever) after the
rotator/retiming-block.

-- =

         Georg Acher, acher@in.tum.de
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
