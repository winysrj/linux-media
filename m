Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JRquI-0001ze-Ln
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 16:30:50 +0100
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JWJ0091WN2CSU30@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Wed, 20 Feb 2008 17:30:12 +0200 (EET)
Received: from spam4.suomi.net (spam4.suomi.net [212.50.131.168])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JWJ00359N2CZU10@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Wed, 20 Feb 2008 17:30:12 +0200 (EET)
Date: Wed, 20 Feb 2008 17:29:59 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <ea4209750802200553g13eb8ef5yb4abc2c1e012b803@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>
Message-id: <47BC4777.7080206@iki.fi>
MIME-version: 1.0
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
	<47B9D533.7050504@iki.fi>
	<ea4209750802181306tcc8c98clff330d4289523d96@mail.gmail.com>
	<47BA011D.9060003@iki.fi>
	<ea4209750802181424q4ac90c7ag33ad8b8d79e258fd@mail.gmail.com>
	<47BA0C4D.4070102@iki.fi>
	<ea4209750802181530p7bd2ec78j562e7fdf281890b5@mail.gmail.com>
	<47BC2189.8070308@iki.fi>
	<ea4209750802200553g13eb8ef5yb4abc2c1e012b803@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
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

Albert Comerma wrote:
> Is it a coincidence, but there have been updates in kaffeine 
> (0.8.5-35.pm <http://0.8.5-35.pm>)  (libxine1, libxine1-dvb version: 
> 1.1.9-1-0.pm <http://1.1.9-1-0.pm> , for example) and since then 
> everything works. To be confirmed in time.
> 
> So please try if you can use this versions (or newer) and let me know.

xinelib is even newer and Kaffeine version is same. I doubt that xinelib 
and Kaffeine has any effect. It should lock and find PIDs even without 
xinelib when using dvb-apps tools. xinelib and Kaffeine has only effect 
when viewing picture.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
