Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Mon, 18 Aug 2008 20:24:04 +0200
References: <200808181427.36988.ajurik@quick.cz> <48A9BAFE.8020501@linuxtv.org>
In-Reply-To: <48A9BAFE.8020501@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808182024.04637.ajurik@quick.cz>
Subject: Re: [linux-dvb] HVR-4000 driver problems - i2c error
Reply-To: ajurik@quick.cz
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

On Monday 18 of August 2008, Steven Toth wrote:
> Ales Jurik wrote:
> > Hi,
> >
> > I've got a HVR-4000, but I have now some very strange problems.
> > I have Debian Leeny with 2.6.25-2 kernel and multiproto from Igor
> > Lipianin hg running at Athlon64 X2 2700+ and Asus M2N-DVI mobo.
> > Whole multiproto tree compiled without any problem.
> >
> > - when starting system I got this message:
> >
> > [   24.658572] tda9887 0-0043: i2c i/o error: rc == -121 (should be 4)
> > [   24.659047] tuner-simple 0-0061: i2c i/o error: rc == -121 (should be
> > 4) [   23.609971] tda9887 0-0043: i2c i/o error: rc == -121 (should be 4)
> >
>
> I fixed an issue with cx88 sometime ago where a value of 0 (taken from
> the cards struct) was being written to the GPIO register, resulting in
> the same i2c issues.
>
> It looks a lot like this.
>
> - Steve

Yes, after few hours using google I also found such remarks, but please could 
you be more specific? I don't have any documentation for chips used at 
HVR-4000.

Thanks,

Ales


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
