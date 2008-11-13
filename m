Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out4.libero.it ([212.52.84.104])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ferrarir@libero.it>) id 1L0lJN-0000Qs-9K
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 00:09:18 +0100
Received: from libero.it (192.168.17.9) by cp-out4.libero.it (8.5.016.1)
	id 491979DC0050CC28 for linux-dvb@linuxtv.org;
	Fri, 14 Nov 2008 00:08:40 +0100
Date: Fri, 14 Nov 2008 00:08:40 +0100
Message-Id: <KAAOAG$CEA59BC3D735B9AA0A1D487608AA9862@libero.it>
MIME-Version: 1.0
From: "ferrarir\@libero\.it" <ferrarir@libero.it>
To: "dvb linux" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Help with multiproto and myth
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

Thank you for your reply!
Can you tell me if is there a way dump a dvb-s2 stream to a file?
I'm able to lock dvb-s2 channels using szap2 (i got FE_HAS_LOCK) but don't know how to watch them...
Do i need particular codecs? (I'm able to watch h.264/avc1 files.)
(i want to be sure that my multiproto drivers are ok before going to mythtv ml)

thanks

---------- Initial Header -----------

>From      : "Per Heldal" heldal@eml.cc
To          : "ferrarir@libero.it" ferrarir@libero.it
Cc          : 
Date      : Thu, 13 Nov 2008 00:02:31 +0100
Subject : Re: [linux-dvb] Help with multiproto and myth







> On Wed, 2008-11-12 at 19:42 +0100, ferrarir@libero.it wrote:
> > Hello,
> > i'm having problem watching dvb-s2 channels using multiproto drivers
> > and mythtv.
> > i've compiled multiproto drivers and mythtv 0.21 patched with this
> > patch:
> > http://svn.mythtv.org/trac/raw-attachment/ticket/5403/mythtv_multiproto.5.patch
> > i'm able to scan dvb-s2 transponders after updating
> > mythconverg.dtv_multiplex table to '8psk' (modulation field) but i'm
> > not able to watch hd channels ...
> > Mythfrontend complains about "no lock"
> 
> You're more likely to find help about mythtv on one of their
> mailinglists.  See http://mythtv.org/modules.php?name=MythInfo
> 
> Patience is probably the key right now when it comes to linux and
> DVB-based HDTV. In case you haven't noticed; the community has agreed
> that S2API, and not multiproto, is the way forward. The new API and a
> collection of hardware drivers to go with it is intended for inclusion
> with linux kernel release 2.6.28 some time next year. In the meantime
> there's only experimental code available. Some application developers
> have started coding for the new API, but there's no working patches for
> mythtv yet. There is experimental code for VDR and Kaffeine.
> 
> S2API source: http://linuxtv.org/repo/   (v4l-dvb source tree)
> About S2API: http://linuxtv.org/wiki/index.php/S2API
> 
> 
> 
> -- 
> 
> 
> Per Heldal - http://heldal.eml.cc/
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
