Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <480209DB.5070801@optusnet.com.au>
Date: Sun, 13 Apr 2008 22:55:47 +0930
From: Darrin Ritter <darrinritter@optusnet.com.au>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <47FDAD31.6030901@optusnet.com.au> <47FE0DA1.5050302@linuxtv.org>
In-Reply-To: <47FE0DA1.5050302@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Conexant CX23880 suspected driver memory leak
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

Hi Steven.

Thanks for your willingness to look into my concern. I was unable to 
find any sign of memory usage increase with dvbstream, actually it 
stayed a rock steady 144kb there seems to be some sort of randomness to 
the problem somewhere in the software stack.

Thanks to all who developed the CX23880 driver

Darrin Ritter


Steven Toth wrote:
>
>> I tested the application for an hour and the memory usage stayed at a 
>> steady 14.6 Mb, given the previous tests I would have expected the 
>> memory usage to rise to approx 26.6 Mb
>
> Thanks Darrin.
>
> I'll fix it if you can prove the leak with dvbstream.
>
> http://sourceforge.net/projects/dvbtools/
>
> Can you?
>
> - Steve
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
