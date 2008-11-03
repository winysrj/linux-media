Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeisom@gmail.com>) id 1Kx00H-0001uC-PT
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 15:02:02 +0100
Received: by an-out-0708.google.com with SMTP id b38so21243ana.41
	for <linux-dvb@linuxtv.org>; Mon, 03 Nov 2008 06:01:55 -0800 (PST)
Message-ID: <1767e6740811030601g3c5f9b3aw9e93f878703b644d@mail.gmail.com>
Date: Mon, 3 Nov 2008 08:01:55 -0600
From: "Jonathan Isom" <jeisom@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <38dc7fce0811030052i1eb70355v8b18df3dd9d3ac5c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <38dc7fce0811030052i1eb70355v8b18df3dd9d3ac5c@mail.gmail.com>
Subject: Re: [linux-dvb] buffer overflow error.
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

On Mon, Nov 3, 2008 at 2:52 AM, YD <ydgoo9@gmail.com> wrote:
> Hello, All
>
> I got a error. "dmxdev: buffer overflow" sometimes. especially
> recording the files from 2 frontend devices.
> My modification is that I changed the buffer size 10*188*1024 --> 20*188*1024.
> But I still gets this error.
> It is caused from the system load or performance ? I do not understand
> why this happen.
>
> Please give me some comments or help.

It may help if you supply info about the cards used, and drivers versions used.

Later

Janathan

> Thanks,
> youngduk
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
