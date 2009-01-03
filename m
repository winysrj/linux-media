Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redtux1@googlemail.com>) id 1LJ4xp-000496-Jp
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 12:46:47 +0100
Received: by bwz11 with SMTP id 11so14478162bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 03:46:12 -0800 (PST)
Message-ID: <ecc841d80901030346g738bde61rd3b529274d5fb69b@mail.gmail.com>
Date: Sat, 3 Jan 2009 11:46:11 +0000
From: "Mike Martin" <redtux1@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <alpine.DEB.2.00.0901031058380.32128@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
References: <ecc841d80901022041w72031858pc9b7bf6b6cb199fb@mail.gmail.com>
	<alpine.DEB.2.00.0901031058380.32128@ybpnyubfg.ybpnyqbznva>
Subject: Re: [linux-dvb] Is it posible to view digital teletext
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

On 03/01/2009, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:
> On Sat, 3 Jan 2009, Mike Martin wrote:
>
>> Does anyone know if it is possible to view dvb teletext through linux
>
> Yes, but first, in your subject, you ask about Digital
> Teletext which, in the UK, at least over satellite (Freesat)
> is MHEG, while Sky uses the proprietary OpenWozzit, and
> here you ask about DVB Teletext, as used by most of the
> rest of the world (when not MHP), and which is different...
>
>

Well it is DVB teletext ie:through DVB-T not satelite of any description
>> if i am getting the right pid
>
> The PID for DVB Teletext will be given on the PMT, as will
> the necessary info for the MHEG carousels.  Note that over
> satellite, pretty much the only DVB teletext is subtitles
> on page 888 for the large channels (BBC, ITV, C4, etc),
> and only Five has regular teletext pages otherwise.
>

AFAIK all the commercial channels provide a "teletext" service

This is the output of dvbtune -i

<service id="12928" ca="0">
<description tag="0x48" type="1" provider_name="five" service_name="FIVER" />
<stream type="2" pid="6673">
<stream_id id="7" />
</stream>
<stream type="4" pid="6674">
<iso_639 language="eng" type="0" />
<stream_id id="145" />
</stream>
<stream type="4" pid="6675">
<iso_639 language="eng" type="3" />
<stream_id id="155" />
</stream>
<stream type="6" pid="6678">
<subtitling_descriptor tag="0x59">
<subtitle_stream lang="eng" type="16" composition_page_id="0002"
ancillary_page_id="0002" />
</subtitling_descriptor>
</stream>
</service>

May be being very thick, but there is nothing that stands out

ouput from quickscan (from libdvb) gives
      CHANNEL ID 0 NAME "Five" PNAME "five" SATID 3e8 TPID 3e8 SID
3242 TYPE 0 VPID 1781 APID 1782 APID 1783 PCRPID 1781 SUBPID 1786

I'm guessing this would be the right PID
TPID 3e8

> Check out `redbutton-download' and `redbutton-browser'
> for an application that can display MHEG pages, as sent
> out by at least the Beeb last time I looked, shortly
> before the official launch of Freesat, which was written
> for DVB-T, but also works for select Freesat DVB-S.
>
>
>> Any help apreciated  (I am in the UK)
>
> Probably the above is what you need.  For regular DVB
> teletext, like Five via Freesat, I use `dvbstream' on
> the teletext PIDs from a particular transponder, piped
> to a hacked version of `jpvtx' that writes the individual
> pages.  For viewing, there's an X-aware `xvtx-p', or I've
> a heavily hacked `vtx-to-utf8' from the `jpvtx' package
> (originally not UTF8 but to 8859-15 with added support
> for colours, non-ASCII characters, and limited graphics)
>
>
> hope this is helpful
> barry bouwsma
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
