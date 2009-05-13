Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750860AbZEMH1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 03:27:21 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 13 May 2009 09:27:19 +0200
From: "Peter Forstmeier" <2Pet@gmx.de>
Message-ID: <20090513072719.48980@gmx.net>
MIME-Version: 1.0
Subject: OpenSuse 11.1 + v4l
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
i tried to build v4l and did tho following:

peter@linux-d9lb:~> hg clone http://linuxtv.org/hg/v4l-dvb
destination directory: v4l-dvb                            
requesting all changes                                    
adding changesets                                         
adding manifests                                          
adding file changes                                       
added 11759 changesets with 29793 changes to 2019 files   
updating working directory                                
1448 files updated, 0 files merged, 0 files removed, 0 files unresolved
peter@linux-d9lb:~> hg clone http://linuxtv.org/hg/dvb-apps            
destination directory: dvb-apps                                        
requesting all changes                                                 
adding changesets                                                      
adding manifests                                                       
adding file changes                                                    
added 1275 changesets with 5390 changes to 1814 files                  
updating working directory                                             
1315 files updated, 0 files merged, 0 files removed, 0 files unresolved peter@linux-d9lb:~> cd v4l-dvb peter@linux-d9lb:~/v4l-dvb> hg pull -u http://linuxtv.org/hg/v4l-dvb
pulling from http://linuxtv.org/hg/v4l-dvb                          
searching for changes                                               
no changes found   

Doing 'make'

    make make -C /home/peter/v4l-dvb/v4l
make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
No version yet, using 2.6.27.7-9-pae
make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
scripts/make_makefile.pl
Updating/Creating .config
Preparing to compile for kernel version 2.6.27 File not found: /lib/modules/2.6.27.7-9-pae/build/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.27 File not found: /lib/modules/2.6.27.7-9-pae/build/.config at ./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** Keine Regel vorhanden, um das Target ».myconfig«,
  benötigt von »config-compat.h«, zu erstellen.  Schluss.
make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
make: *** [all] Fehler 2
peter@linux-d9lb:~/v4l-dvb>

Any idea's about that.

Thanks
Peter
                                             

-- 
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschluss für nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surfflat/?ac=OM.AD.PD003K11308T4569a
