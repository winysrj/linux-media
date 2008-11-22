Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeisom@gmail.com>) id 1L3uSg-0003Kq-OI
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 16:31:56 +0100
Received: by yw-out-2324.google.com with SMTP id 3so579735ywj.41
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 07:31:50 -0800 (PST)
Message-ID: <1767e6740811220731s17b313edl2947374210054eab@mail.gmail.com>
Date: Sat, 22 Nov 2008 09:31:49 -0600
From: "Jonathan Isom" <jeisom@gmail.com>
To: "Linux DVB" <linux-dvb@linuxtv.org>
In-Reply-To: <1767e6740811032017x63c1f635u34db2e6e919c2ce7@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1767e6740811032017x63c1f635u34db2e6e919c2ce7@mail.gmail.com>
Subject: Re: [linux-dvb] bug with kworld atsc 110/115
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

On Mon, Nov 3, 2008 at 10:17 PM, Jonathan Isom <jeisom@gmail.com> wrote:
> Hi all
>    I have been using dvbstreamer(not to be confused with dvbstream)
> and at svn revision r520
> of dvbstreamer Adam the author introduced a change in it that causes
> my system to hardlock.
> The change was if the frontend lost signal lock to Stop all filters
> and to start them back up when
> signal locked.  Simply by switching transponders I can hard lock the
> system in about 1 minute..
> Reproducable with kworld atsc 110 and 115(not surprising).  nothing is logged.

Forgot to say tested a 2.6.25, 2.6.26 and 2.6.27 kernel.   Is anyone
looking into this?

Thanks

Jonathan

>
> Thanks
>
> Jonathan
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
