Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator4.ecc.gatech.edu ([130.207.185.174]:36170 "EHLO
	deliverator4.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbZEMNug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 09:50:36 -0400
Received: from deliverator4.ecc.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 6A9A15E4255
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 09:50:37 -0400 (EDT)
Received: from mail1.gatech.edu (bigip.ecc.gatech.edu [130.207.185.140])
	by deliverator4.ecc.gatech.edu (Postfix) with ESMTP id 6F0C25E416A
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 09:50:36 -0400 (EDT)
Received: from [192.168.2.131] (bigip.ecc.gatech.edu [130.207.185.140])
	(Authenticated sender: gtg131s)
	by mail1.gatech.edu (Postfix) with ESMTP id 4D220C2F2D
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 09:50:36 -0400 (EDT)
Message-ID: <4A0AD02B.6000208@gatech.edu>
Date: Wed, 13 May 2009 09:50:35 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: OpenSuse 11.1 + v4l
References: <20090513072719.48980@gmx.net>
In-Reply-To: <20090513072719.48980@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/13/2009 03:27 AM, Peter Forstmeier wrote:
> Hi,
> i tried to build v4l and did tho following:
>
> peter@linux-d9lb:~>  hg clone http://linuxtv.org/hg/v4l-dvb
> destination directory: v4l-dvb
> requesting all changes
> adding changesets
> adding manifests
> adding file changes
> added 11759 changesets with 29793 changes to 2019 files
> updating working directory
> 1448 files updated, 0 files merged, 0 files removed, 0 files unresolved
> peter@linux-d9lb:~>  hg clone http://linuxtv.org/hg/dvb-apps
> destination directory: dvb-apps
> requesting all changes
> adding changesets
> adding manifests
> adding file changes
> added 1275 changesets with 5390 changes to 1814 files
> updating working directory
> 1315 files updated, 0 files merged, 0 files removed, 0 files unresolved peter@linux-d9lb:~>  cd v4l-dvb peter@linux-d9lb:~/v4l-dvb>  hg pull -u http://linuxtv.org/hg/v4l-dvb
> pulling from http://linuxtv.org/hg/v4l-dvb
> searching for changes
> no changes found
>
> Doing 'make'
>
>      make make -C /home/peter/v4l-dvb/v4l
> make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
> No version yet, using 2.6.27.7-9-pae
> make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
> make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
> scripts/make_makefile.pl
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.27 File not found: /lib/modules/2.6.27.7-9-pae/build/.config at ./scripts/make_kconfig.pl line 32,<IN>  line 4.
> make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
> make[1]: Entering directory `/home/peter/v4l-dvb/v4l'
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.27 File not found: /lib/modules/2.6.27.7-9-pae/build/.config at ./scripts/make_kconfig.pl line 32,<IN>  line 4.
> make[1]: *** Keine Regel vorhanden, um das Target ».myconfig«,
>    benötigt von »config-compat.h«, zu erstellen.  Schluss.
> make[1]: Leaving directory `/home/peter/v4l-dvb/v4l'
> make: *** [all] Fehler 2
> peter@linux-d9lb:~/v4l-dvb>
>
> Any idea's about that.
>
> Thanks
> Peter
>    
I believe you do not have the kernel header files installed.  Under 
OpenSUSE it looks like there isn't a separate package for the kernel 
headers, so you just need to install the full kernel sources instead 
(the kernel-source RPM).
