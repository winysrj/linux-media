Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KEQGU-0004hk-2v
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 16:58:33 +0200
Message-ID: <486CE911.8090808@iki.fi>
Date: Thu, 03 Jul 2008 17:58:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair M <tlli@hotmail.com>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>	<486B3617.3070702@iki.fi>
	<BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>	<486CB3D2.3000702@iki.fi>
	<BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>	<486CCF9E.7070109@iki.fi>
	<BAY136-W13F407BF8A0BCA5BB251F6D2980@phx.gbl>	<486CDC62.5060605@iki.fi>
	<BAY136-W4A1D1267A59B878FF68C7D2980@phx.gbl>
In-Reply-To: <BAY136-W4A1D1267A59B878FF68C7D2980@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
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

should be fixed now!

regards
Antti

Alistair M wrote:
> Ah great news...!
> 
>  > Date: Thu, 3 Jul 2008 17:04:18 +0300
>  > From: crope@iki.fi
>  > To: tlli@hotmail.com
>  > CC: linux-dvb@linuxtv.org
>  > Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
>  >
>  > Alistair M wrote:
>  > > Hello Antii,
>  > > I have compiled in your latest build.
>  > >
>  > > What seems to be happening is, in the terminal or even a text editor,
>  > > when i press any button on the remote control, that character (eg. 0)
>  > > will be repeated as text on the terminal or text editor. So if i for
>  > > instance press the key 0 on the remote, while i have a text editor 
> open,
>  > > it enters the number 0 continuously, like this:
>  > > 000000000000000000000000000000... in the editor, or terminal 
> window, or
>  > > any text input field.
>  >
>  > hmm, I think I know the reason. Actually this is due to hardware bug. I
>  > think I have older silicon revision that returns error code when polling
>  > remote events and there is no event. You have a newer silicon that does
>  > not return error any more. Current remote polling code in the driver
>  > relies that error code. I will fix that soon, it is easy to fix.
>  >
>  > > Does that make sense...
>  > > Its past midnight here in Australia so i have to get to bed as i 
> have to
>  > > work tomorrow, i'll email back in the morning.
>  > > Thank you Antii.
>  > > Alistair.
>  >
>  > regards
>  > Antti
>  > --
>  > http://palosaari.fi/
> 
> ------------------------------------------------------------------------
> Find a new job on Seek Increase your salary. 
> <http://a.ninemsn.com.au/b.aspx?URL=http%3A%2F%2Fninemsn%2Eseek%2Ecom%2Eau%2F%3Ftracking%3Dsk%3Amtl%3Ask%3Anine%3A0%3Ahot%3Atext&_t=764565661&_r=JAN08_endtext_increase&_m=EXT>
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
