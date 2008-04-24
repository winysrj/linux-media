Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1Jp8QV-0000uK-Jo
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 22:52:22 +0200
Received: by fk-out-0910.google.com with SMTP id z22so5031140fkz.1
	for <linux-dvb@linuxtv.org>; Thu, 24 Apr 2008 13:52:14 -0700 (PDT)
Message-ID: <854d46170804241352o5b221ddfldfe040202acb512d@mail.gmail.com>
Date: Thu, 24 Apr 2008 22:52:13 +0200
From: "Faruk A" <fa@elwak.com>
To: "Igor Nikanov" <goga777@bk.ru>
In-Reply-To: <20080424222951.1580e34d@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080424222951.1580e34d@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 & szap2 - ioctl DVBFE_GET_INFO failed:
	Operation not supported
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

On Thu, Apr 24, 2008 at 8:29 PM, Igor Nikanov <goga777@bk.ru> wrote:
> Hi
>
>  I have installed the latest multiproto with hvr4000 patch from Gregoire Favre
>  http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024487.html
>
>  after that I have installed the szap2 from dvb-apps
>  But with szap2 I have the error ioctl DVBFE_GET_INFO failed: Operation not supported
>  Can somebody comment ?
>
>  # ./szap2 -c 19 -n1
>
>  reading channels from file '19'
>  zapping to 1 'Pro7':
>  sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid = 0x0103 sid = 0x27d8
>  Querying info .. Delivery system=DVB-S
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  ioctl DVBFE_GET_INFO failed: Operation not supported
>
>
>  Igor
>

Hi

Try this patch.

wget -O szap-multiproto-apiv33.diff
http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080406/a365d65c/attachment.bin

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
