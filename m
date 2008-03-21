Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n8.bullet.ukl.yahoo.com ([217.146.182.188])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JcjMi-0003wx-2y
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 16:41:10 +0100
Date: Fri, 21 Mar 2008 11:29:41 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D102397D@w2k3sbs.glcdomain.local>
	(from michael.curtis@glcweb.co.uk on Wed Mar 19 17:39:49 2008)
Message-Id: <1206113381l.5668l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  DVB-S DVB-S2 and CI cards working on Linux
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

On 03/19/2008 05:39:49 PM, Michael Curtis wrote:
> 
> 
> I have repeated my question and BTW thank you to those that responded
> earlier
> 
> But I have to say that no one has answered the question that I posed 
> 
> "Are there any DVB-S/S2/CI cards that work at present on Linux? If so
> I
> would really appreciate knowing which ones they are"
> 
> Is there anyone that is watching either FTA DVB-S, DVB-S2 and/or
> decrypted program material via a CI, on a linux box?
> 
> ----------------------------------------------------------------------
> 
> 
> First of all my thanks to all those engaged in developing drivers for
> the various cards for the Linux OS and my apologies for repeating 
> this
> question previously asked by others
> 
> 
> Are there any DVB-S/S2/CI cards that work at present on Linux? If so 
> I
> would really appreciate knowing which ones they are
> 
> 
> I have had a TT3200 DVB-S2/CI card for more than a year and I have
> still
> not got this to work using the Multiproto drivers on Linux, in fact 
> it
> seem that I am going backwards with this card with the latest errors
> appearing in dmesg:
> 
> stb0899_search: Unsupported delivery system
> 
> This is with the latest drivers from "http://jusst.de/hg/multiproto"
> 
> Changeset 7212:b5a34b6a209d
> 
> I will gladly offer up the log/dmesg/lsmod information if someone can
> help
> 
> At the moment, I feel frustrated and lack the confidence that working
> drivers are are going to be available for this card
> 
> Kind Regards

I was using a TT S-1500+CI with aston CAM and enjoying DVB-S crypted 
with no problem.
Now using a TT S-3200, DVB-S+CI works only on some transponders, others 
are a bit unreliable (sometimes corruptd picture, sometimes no lock). 
Hopefully this can be resolved soon.
No DVB-S2 transponders around here, so..
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
