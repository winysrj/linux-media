Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zaheermerali@gmail.com>) id 1JUVw5-0006NV-Hy
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 00:43:41 +0100
Received: by nf-out-0910.google.com with SMTP id d21so1833656nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 15:43:05 -0800 (PST)
Message-ID: <15e616860802271543v349ed837m34784cf4f8fccb77@mail.gmail.com>
Date: Wed, 27 Feb 2008 23:43:04 +0000
From: "Zaheer Merali" <zaheermerali@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
In-Reply-To: <47C5EA9B.3020308@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1204046724.994.21.camel@amd64.pyotr.org>
	<15e616860802270339s25938affsfede0f985111ee5f@mail.gmail.com>
	<47C5EA9B.3020308@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams
	from same mux
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

On Wed, Feb 27, 2008 at 10:56 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Zaheer Merali wrote:
>
>  > So we don't take the whole multiplex into userspace, just the pids we
>  > need on an as needed basis.
>
>  Though this will work for FTA streams, it won't work for scrambled streams.
>
>  Regards,
>  Manu
>

Maybe I gave a simplistic description fo what we do, but I can confirm
we have encrypted streams decrypted also with dvbbasebin in gstreamer
talking to the cam. It was done in last year's Summer of Code by
Alessandro Decina.

Zaheer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
