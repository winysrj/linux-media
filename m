Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1Js0XO-0003xy-Tf
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 21:03:19 +0200
Received: by yw-out-2324.google.com with SMTP id 5so35924ywb.41
	for <linux-dvb@linuxtv.org>; Fri, 02 May 2008 12:02:58 -0700 (PDT)
Message-ID: <37219a840805021202w57218167x9e0949e01575125b@mail.gmail.com>
Date: Fri, 2 May 2008 15:02:58 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Robert Penland" <penland@pacbell.net>
In-Reply-To: <DD4A3CFD-1E9F-4629-BC0F-117AF495F3BF@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <DD4A3CFD-1E9F-4629-BC0F-117AF495F3BF@pacbell.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1250 Analog mode
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

On Fri, May 2, 2008 at 1:17 PM, Robert Penland <penland@pacbell.net> wrote:
> Has any progress been made on getting the analog mode of the HVR-1250
>  working?  I looked through the recent archives, but didn't see any
>  relevant information.

Analog video is not yet supported by the linux cx23885 driver for
Conexant cx23885 PCIe bridge chipsets.

Currently, the linux cx23885 driver only supports analog video on the
Conexant cx23887 PCIe bridge chipset.

The HVR-1800 uses a cx23887, but the HVR-1250 uses a cx23885 -- only
digital television is supported at this time.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
