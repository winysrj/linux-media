Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73IxThj016334
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 14:59:29 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m73IxEtP025705
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 14:59:14 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Lars Oliver Hansen <lolh@ymail.com>, video4linux-list@redhat.com
In-Reply-To: <1217760210.5580.7.camel@lars-laptop>
References: <1217690263.6605.25.camel@lars-laptop>
	<1217719945.2676.6.camel@pc10.localdom.local>
	<1217760210.5580.7.camel@lars-laptop>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 03 Aug 2008 20:52:37 +0200
Message-Id: <1217789557.2676.139.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: saa7134-alsa  appears to be broken
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hallo Lars,

I send a copy to the list anyway, even you seem to prefer German.

Am Sonntag, den 03.08.2008, 12:43 +0200 schrieb Lars Oliver Hansen:
> Hallo Herrmann,
> 
> Am Sonntag, den 03.08.2008, 01:32 +0200 schrieb hermann pitton: 
> > Hi Lars,
> > 
> > Am Samstag, den 02.08.2008, 17:17 +0200 schrieb Lars Oliver Hansen:
> > > Hi,
> > > 
> > > I experience the same problem: the sound part of the saa7134 driver
> > > doesn't load.
> .... 
> > 
> > please report this again from a 2.6.26.1 or every other vanilla kernel
> > of you choice.
> > 
> > We had some minor issues, but I refuse to investigate what others
> > deliberately add.
> > 
> > Cheers,
> > Hermann
> > 
> > BTW: in kernel drivers follow the kernel versions since ever.
> 
> Ich verwende Ubuntu 8.04 und weiß noch nicht, wie ich den Kernel
> upgraden kann ohne Abhängigkeiten in Ubuntu zu verlieren. Überhaupt
> weiß ich noch nicht, wie ich ein Kernel von Kernel.org compilieren
> muss, was ich alles tun muss und brauche, damit jeder Bestandteil
> meiner Ubuntu Installation noch funktioniert :-).
> Wenn ich hier irgendeinen Test ausführen kann oder hier irgendwelche
> Informationen abrufen kann, die dir/euch weiterhelfen, tue ich das
> gerne!
> 
> Grüße,
> 
> Lars

Leider geht das jetzt schon seit Monaten so mit Ubuntu und alsa.

Habe es nicht, aber sie verwenden wohl eine alsa Version, die mit der im
regulären Kernel nicht kompatibel ist.

Es gibt wohl Möglichkeiten aktuelles v4l-dvb mit saa7134-alsa trotzdem
erfolgreich zu kompilieren, aber dazu muss man sich mit dem build system
dort beschäftigen. Es scheint zu genügen zu den richtigen lum alsa
headers zu linken.

Zuerst fehlte saa7134-alsa wohl komplett, dann wurde gegen inkompatible
header gelinkt. Sollte mit aktuellem Ubuntu Kernel jetzt in Ordnung
sein. Ab 2.6.24-16 Hardy Heron RC ?

Probiere mal Google mit "ubuntu saa7134-alsa".

Hier ist ein Link zum Fix von Tim Gardner.
https://bugs.launchpad.net/ubuntu/+source/linux-ubuntu-modules-2.6.24/+bug/192559

Das vorher von mir empfohlene "make rminstall" bezieht sich auf
aktuelles v4l-dvb von linuxtv.org.

Nach "make" sollte man mit "make rmmod" zunächst alle Module entladen.
Falls das Skript auf wirklich alten Kernen nicht mehr alles erwischt, 
sollte man später einen Reboot in Erwägung ziehen oder selbst nachhelfen.

Wenn man einen älteren Kernel hat, also nicht 2.6.27-rc1 oder wenigstens
2.6.26, kann es vorkommen, dass dort noch alte Module, die kürzlich
umbenannt oder komplett entfernt wurden, vorhanden sind und vom
aktuellen "make rminstall" auch nicht entfernt werden.

Etwa das früher video-buf.ko genannte Modul auf <= 2.6.23 blieb eine
Weile zurück, wird aber jetzt erfasst. 
Das als veraltet entfernte saa7134-oss behält man dagegen immer noch. 

Falls vorhanden, muss man solche dann selbst entfernen.

Das gilt auch für saa7134-alsa, das etwa bei einer früheren Kompilierung
aktiviert war, jetzt aber mit zum Beispiel make xconfig/menuconfig
abgewählt ist. Ohne "make rminstall" könnte ein inkompatibles älteres
saa7134-alsa Modul zurück bleiben.

Man kann auch einfach nach "make rmmod" den
kompletten /lib/modules/Deine_Kernelversion/kernel/drivers/media
Ordner löschen oder für ein Backup verschieben.

Das ist eine ziemlich sichere Methode :) und die zeigt auch sofort
eventuell fehlende Module, die gerade auf einem sehr alten Kernel
vielleicht nicht mehr alle mit "make" (all) automatisch bereit gestellt
werden oder die Inkompatibilitäten mit "make xconfig" und Selektivität
haben können. 

Ein 2.6.24 sollte aber definitiv keine besonderen Probleme haben.
Das weiß man aber erst dann wirklich, nachdem _alle_ möglichen Varianten
getestet sind.

Mit "make install", welches am Ende auch das beim Verändern von Modulen
immer notwendige "depmod -a" ausführt, hat man dann aber auch auf einem
älteren Kernel ein konsistentes und aktuelles v4l-dvb.

Als Restrisiko bleibt, dass eine Distribution Module in einem anderen
Ordner als media haben kann oder man kann auch noch Module von einem
anderen Anbieter irgendwo sonst installiert haben, die immer noch nicht
entfernt sind.

In der Regel hilft es hier modprobe mit der -v Option zu verwenden.

So sieht man von wo die Module geladen werden und auch ob andere
Einstellungen, eingetragen etwa durch Anwendungen, die bei der
Systemkonfiguration helfen sollen, die eigene Kommandozeile beim Laden
überschreiben.

Viel Glück und einen schönen Sonntag,

Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
