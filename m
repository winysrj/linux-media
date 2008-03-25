Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Je37a-0000Hb-Kj
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 07:58:59 +0100
Received: by an-out-0708.google.com with SMTP id d18so2429401and.125
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 23:58:43 -0700 (PDT)
Message-ID: <1a297b360803242358t4da80eb1q809bbafbbd2ee45e@mail.gmail.com>
Date: Tue, 25 Mar 2008 10:58:43 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Mark Spieth" <mark@digivation.com.au>
In-Reply-To: <006d01c88e06$25cb0830$a101a8c0@sigtec.com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <006d01c88e06$25cb0830$a101a8c0@sigtec.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] best mxl500x repo
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

On Tue, Mar 25, 2008 at 3:23 AM, Mark Spieth <mark@digivation.com.au> wrote:
> hi
>
>  which is the best mxl500x repo to use, manu or stoth?
>  I have a kworld dual plus 399U afatech which uses this tuner and I want to
>  merge the mxl500x tuner into the anttip repo.

Merging into that repository won't really help much, since the device
is a dual frontend device.
A driver expected from Afatech is expected to have complete
functionality on this.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
