Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <cae4ceb0901091526m2dcad492i66d169f0614a7f3@mail.gmail.com>
Date: Fri, 9 Jan 2009 15:26:34 -0800
From: "Tu-Tu Yu" <tutuyu@usc.edu>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <37219a840901091200h4a2910b2qe1edcc6667efa2d3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <cae4ceb0901091128w6f6e937dv45ac4024907c2a72@mail.gmail.com>
	<37219a840901091200h4a2910b2qe1edcc6667efa2d3@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Does anyone work on Dvico HDTV7 (both s5h1411 and
	s5h1409) sucessfully!?
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

Michael Thank you so much!

Actually, I also tried FusionHDTV5 Lite with the cable which i used
for Fusion HDTV7, it works fine. So i think my cabling is okay.

When HDTV7 TV tuner card stops, it shows

>READ DVR: Value too large for defined data type
>Error reading from ATSC card: exiting
>Read -1 bytes from ATSC DVR instead of 1316

Sometimes before it stops, the snr value goes down from 28~30 to 12~18 (db).
Any ideas?

Best,

Audrey



On Fri, Jan 9, 2009 at 12:00 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Fri, Jan 9, 2009 at 2:28 PM, Tu-Tu Yu <tutuyu@usc.edu> wrote:
>> hi~
>> I am working on Dvico HDTV7 Tv tuner card. For s5h1409 version, it
>> usually works fine in first few hours but after a while it will stop.
>> For S5H1411 version, it usually works fine for only first hours and
>> then it will stop....Can anyone give me some suggestion? I am looking
>> for the solution for more than 1 month.....? Thank you so much!
>
> I have a server running 24/7 with one of each of these boards in it.
> It has two FusionHDTV7 Dual Express boards, one using the 1409, the
> other using the 1411.
>
> The server records EVERYTHING on television, on every channel, and it
> has been running without any problems.
>
> You should check your cabling and power -- this is not a driver issue.
>
> Regards,
>
> Mike Krufky
>

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
