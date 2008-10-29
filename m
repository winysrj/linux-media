Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.nijcomplesk5.nl ([83.172.148.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean-paul@goedee.nl>) id 1KvDGt-0001V1-CD
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 16:47:48 +0100
Message-ID: <20081029164747.h5xzc1hhwo0oocww@webmail.goedee.nl>
Date: Wed, 29 Oct 2008 16:47:47 +0100
From: jean-paul@goedee.nl
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Update: S2API , scan-s2, TT 3200_CI, VDR 1.7.0,
	Streamdev (latest	version)
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

S2API (drivers) latest version compile without error, Compiling  
scan-s2 give a error on DDS or something like that. Remove it from  
scan.c and compile it again.

Scanning booth LNB?s (astra 1  & 3) and only normal S. Try al options  
but no S2 channels.  Compile VDR with S2API patch and streamdev  
plugin. No problem so far. Copy the new channels.conf to the vdr  
directory and start vdr. Tuning to FTA channels is no problem but  
encrypt channels are not available. For so far as I can see the caids  
are correct (verify with the caids of mij production system  (also  
2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse   
streamdev.

No S2 channels, No encrypt channels.

Regards

Jean-Paul






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
