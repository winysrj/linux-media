Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264AbZINWOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 18:14:01 -0400
Date: Mon, 14 Sep 2009 15:13:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alexander.koenig@koenig-a.de
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14174] New: floppy drive not usable more than
 one time after reboot - kernel panic with active DVB
Message-Id: <20090914151340.428fa07c.akpm@linux-foundation.org>
In-Reply-To: <bug-14174-10286@http.bugzilla.kernel.org/>
References: <bug-14174-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun, 13 Sep 2009 15:08:21 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14174
> 
>            Summary: floppy drive not usable more than one time after
>                     reboot - kernel panic with active DVB
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.27.29-0.1-vanilla x86_64 SMP
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: io_other@kernel-bugs.osdl.org
>         ReportedBy: alexander.koenig@koenig-a.de
>         Regression: No
> 
> 
> This bug report is afollow-up of my report already posted in the OPENSuse
> bugzilla at https://bugzilla.novell.com/show_bug.cgi?id=421732
> You can find detailed information of my hardware and software configuration
> there.
> 
> Short System description:
> - CPU:             AMD Phenom X4 9550 4x2.2GHz (95W) 65nm Quad Core
> - Memory:          4GB - 2x2048MB DDR2-800 CL5, Dual Channel 2x1024MB
> - Motherboard:     GIGABYTE GA-MA770-DS3
> - Graphics         NVidia GeForce 7300 GS, 256MB, TV-Out, DVI, PCIe
> - Floppy:          1.44MB
> - 1. hard disk:    500GB Seagate 7200 RPM SATA II
> - 2. hard disk:    500GB Seagate 7200 RPM SATA II
> - DVD-ROM:         Optiarc DDU 1615 16x/48x, IDE
> - DVD-RW:          NEC AD-7200, IDE
> - SCSI-Controller: Adaptec 2940 SCSI adapter,            SCSI ID: 7
> - DVB controller:  Technotrend/Hauppauge DVB card rev2.1
> 
> Symptoms:
> The first command to the floppy drive after re-boot seems to work, all
> subsequent access to the floppy drive - with the same disk or with any other -
> fail (floppy LED is on, floppy drive moves, but no positive result). See log of
> a terminal session below:
> 
> alexande@asterix:~> mdir
>  Volume in drive A has no label
>  Volume Serial Number is 2828-50E1
> Directory for A:/
> 
> autoexec bat      1142 1998-05-15  20:01  autoexec.bat
> setramd  bat       881 1998-05-15  20:01  setramd.bat
> findramd exe      6855 1998-05-15  20:01  findramd.exe
> aspi4dos sys     14386 1998-05-15  20:01  aspi4dos.sys
> aspicd   sys     29620 1998-05-15  20:01  aspicd.sys
> aspi2dos sys     35330 1998-05-15  20:01  aspi2dos.sys
> aspi8u2  sys     40792 1998-05-15  20:01  aspi8u2.sys
> extract  exe     93242 1998-05-15  20:01  extract.exe
> drvspace bin     69079 1998-05-15  20:01  drvspace.bin
> himem    sys     33447 1998-05-15  20:01  himem.sys
> ebd      cab    276324 1998-05-15  20:01  ebd.cab
> country  sys     30742 1998-05-15  20:01  country.sys
> mode     com     29815 1998-05-15  20:01  mode.com
> keyb     com     20023 1998-05-15  20:01  keyb.com
> ebd      sys         0 2000-01-08  10:09  ebd.sys
> io       sys    222390 1998-05-15  20:01  io.sys
> config   sys       860 2003-11-16   0:26  config.sys
> readme   txt     16216 1998-05-15  20:01  readme.txt
> ramdrive sys     12823 1998-05-15  20:01  ramdrive.sys
> btcdrom  sys     21971 1998-05-15  20:01  btcdrom.sys
> btdosm   sys     30955 1998-05-15  20:01  btdosm.sys
> aspi8dos sys     37564 1998-05-15  20:01  aspi8dos.sys
> flashpt  sys     64425 1998-05-15  20:01  flashpt.sys
> fdisk    exe     64956 1998-05-15  20:01  fdisk.exe
> command  com     96360 1998-05-15  20:01  command.com
> oakcdrom sys     41302 1998-05-15  20:01  oakcdrom.sys
> display  sys     17191 1998-05-15  20:01  display.sys
> ega      cpi     58870 1998-05-15  20:01  ega.cpi
> keyboard sys     34566 1998-05-15  20:01  keyboard.sys
> msdos    sys         9 2000-01-08  10:09  msdos.sys
> toshv224 sys     13720 2003-11-16   0:24  toshv224.sys
>        31 files           1 415 856 bytes
>                              33 792 bytes free
> 
> alexande@asterix:~> mdir
> init A: non DOS media
> Cannot initialize 'A:'
> alexande@asterix:~> mdir
> init A: non DOS media
> Cannot initialize 'A:'
> alexande@asterix:~> mount /media/floppy
> mount: blockorientiertes Ger__t /dev/fd0 ist schreibgesch__tzt, wird eingeh__ngt
> im Nur-Lese-Modus
> mount: konnte Dateisystemtyp nicht feststellen, und es wurde keiner angegeben
> ---> floppy removed from drive <---
> alexande@asterix:~> mount /media/floppy  
> mount: /dev/fd0 ist kein g__ltiges blockorientiertes Ger__t
>  ---> inserted another floppy into the drive <---
> alexande@asterix:~> mount /media/floppy
> mount: blockorientiertes Ger__t /dev/fd0 ist schreibgesch__tzt, wird eingeh__ngt
> im Nur-Lese-Modus
> mount: konnte Dateisystemtyp nicht feststellen, und es wurde keiner angegeben
>  ---> removed floppy from drive <---
> alexande@asterix:~> mdir
> Can't open /dev/fd0: No such device or address
> Cannot initialize 'A:'
>  ---> inserted floppy into drive <---
> alexande@asterix:~> mdir
> init A: non DOS media
> Cannot initialize 'A:'
> alexande@asterix:~> mdir
> init A: non DOS media
> Cannot initialize 'A:'
> alexande@asterix:~> 
> 
> All disks used for these experiments (Windows 98 installation boot disk, SuSE
> Linux 8.1 boot disk) work perfectly on a openSUSE 10.3 32bit system.
> 
> Both disks work as boot disks on my 64 bit system, the Windows boot disk boots
> into DOS, where all file commands work on the floppy.
> 
> 
> The above behavior is the same with the SUSE kernel and the vanilla kernel, if
> the drivers for my DVB card (Technotrend/Hauppauge DVB card rev2.1) are not
> active. With the SUSE kernel no obvious change with active DVB. 
> 
> With the vanilla kernel, however, 9 of 10 attempts to use the floppy (mdir
> command) lead to a "General protection fault" and "Kernel panic" if DVB is
> active (see attachments).
> 

hm, hard.

Dunno about the floppy problem but this photo you took:
https://bugzillafiles.novell.org/attachment.cgi?id=318005
shows a good solid oops in dvb_dmx_memcopy().

However that's just a memcpy(), and we have no info about who called it.

