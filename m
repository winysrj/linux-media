Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n42.bullet.mail.ukl.yahoo.com ([87.248.110.175])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1Jw08W-0006cG-6y
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 21:26:11 +0200
Date: Tue, 13 May 2008 13:58:33 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200805122042.43456.ajurik@quick.cz>
In-Reply-To: <200805122042.43456.ajurik@quick.cz> (from ajurik@quick.cz on
	Mon May 12 14:42:43 2008)
Message-Id: <1210701513l.6217l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : No lock possible at some DVB-S2 channels with TT
 S2-3200/linux
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

On 05/12/2008 02:42:43 PM, Ales Jurik wrote:
> Hi,
> 
> after Telenor switched from Thor-2 to Thor-5 (0.8W) no lock is
> possible with 
> multiproto(-plus) and TT S2-3200 at these transponders:
> 
> TV4 
> HD;Telenor:11341:vC34M5O35S1:S0.8W:25000:512:0;641=sve:0:B00:1405:70:42:0
> CANAL+ FILM 
> HD;Telenor:11421:hC34M5O35S1:S0.8W:25000:513:644=eng;645=eng:0:B00:3306:70:14:0
> Nat Geo 
> HD;Telenor:11434:vC34M5O35S1:S0.8W:25000:512:640=eng:0:B00:3806:70:38:0
> 
> I'm 100% sure that this problem corresponds with switch from Thor-2 
> to
> Thor-5 
> as it appeared exactly at times when switch was announced by Telenor. 
> 
> Regarding to official document 
> http://www.telenorsbc.com/upload/PDFS/DVB-S2%20Transponder%20FEC%
> 20Change_280208.pdf
> 
> two changes were implemented - FEC from 2/3 to 3/4 and switch off
> Pilot.
> 
> On the same HW under Windows it is running ok.
> 
> If somebody could point me to any direction I'll glad to cooperate in 
> debugging.
> 

Perhaps you can try to increase the freq by 4Mhz, that's what I did 
here (DVB-S though) and I have a perfect picture since then.
HTH
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
