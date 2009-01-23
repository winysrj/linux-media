Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ayden.softclick-it.de ([217.160.202.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tobi@to-st.de>) id 1LQSas-0002Ph-PI
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 21:25:36 +0100
Received: from [192.168.3.100] (p57A38AA9.dip0.t-ipconnect.de [87.163.138.169])
	(authenticated bits=0)
	by ayden.softclick-it.de (8.12.3/8.14.0/3.1.1/UNIX) with ESMTP id
	n0NKP0F7023252
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 21:25:01 +0100
Message-ID: <497A27F7.8020201@to-st.de>
Date: Fri, 23 Jan 2009 21:26:31 +0100
From: =?ISO-8859-1?Q?Tobias_St=F6ber?= <tobi@to-st.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
Reply-To: linux-media@vger.kernel.org
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

Well, just have to send this message again, this time to the right & 
correct mailing list linux-dvb@linuxtv.org. (Who by the way had the 
insane idea, to set a reply-to address to another mailing list 
(linux-media@vger.kernel.org)? I've never seen such behavior in other 
lists. It's a damn useless and confusing thing.)

Moin, moin (as people say in Northern Germany) :)

BOUWSMA Barry schrieb:
> I've just learned that effective 24.Feb, there will be a change
> made to the channel assignment in the area of Hamburg.
> 
> This is due to the fact that one existing multiplex is found
> within the VHF band, which is in the process of being cleared
> of DVB-T services, moving them to assigned UHF channels, in
> order to free the VHF band for radio services (DAB/DAB+ and
> family).
> 
> Several other areas, such as Bayern, currently make use of
> VHF frequencies at several transmitter sites.  I am not yet
> aware of what plans exist to change these frequencies...

As for certain area in Saxony-Anhalt, Saxony and Thuringia there ahve
never been VHF channels in use. Tis applies normally only to area from
the first stage of the German DVB-T project.

Lower Saxony has recently (November 2008) cleared several channels, like
in my area (Brunswick), where there had been an ARD Mux on Ch 8. Now  it
  is on Ch 47.

> The following diff will add the newly assigned frequency,
> and remove the old one, with an effective date of 24.Feb.
> 
> The particular modulation parameters are not confirmed, so
> I've had to guess based on existing values used elsewhere
> in the NDR coverage area as well as what generally is used
> throughout germany.

Information for the whole NDR area will normally be found at
http://www.dvb-t-nord.de.

There is a complete listing including parameters from "in area" and also
"out of area" (but with reception in the area) transmitters at

http://www.ueberallfernsehen.de/data/senderliste_25_11_2008.pdf

So have a look ;)

Best regards, Tobias


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
