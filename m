Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KZ2uK-0006RC-JW
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 14:16:54 +0200
Received: by fg-out-1718.google.com with SMTP id e21so529017fga.25
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 05:16:49 -0700 (PDT)
Message-ID: <37219a840808290516j7a670704u796620518fe0f78@mail.gmail.com>
Date: Fri, 29 Aug 2008 08:16:49 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808291356540.17297@pub3.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
	<alpine.LRH.1.10.0808291157060.17297@pub3.ifh.de>
	<Pine.LNX.4.64.0808292129330.21301@loopy.telegraphics.com.au>
	<alpine.LRH.1.10.0808291356540.17297@pub3.ifh.de>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [PATCH] Add support for the
	Gigabyte R8000-HT USB DVB-T adapter
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Fri, Aug 29, 2008 at 7:58 AM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> You can find it here:
>
> http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/
>
> 5878ebfcba2d8deb90b9120eb89b02da  dvb-usb-dib0700-1.10.fw
>
> Patrick.

Patrick and Finn,

Please note that I sent this pull request to Mauro yesterday:

http://linuxtv.org/hg/~mkrufky/bristol

- dib0700: add comment to identify 35th USB id pair
- dib0700: add basic support for Hauppauge Nova-TD-500 (84xxx)

 dib0700_devices.c |    9 +++++++--
 dvb-usb-ids.h     |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

...it might just be a better idea to regenerate the patch against this
tree, to avoid a merge conflict.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
