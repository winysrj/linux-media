Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34593 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbbFCTYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 15:24:54 -0400
Received: by lbcmx3 with SMTP id mx3so13734043lbc.1
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 12:24:52 -0700 (PDT)
MIME-Version: 1.0
From: Nico Herpich <nico.herpich@online.de>
Date: Wed, 3 Jun 2015 21:24:12 +0200
Message-ID: <CABSbMOHSD1Te3rJKjkXa2asrVgFgSjTRzDB_0df4+JiCs3PONg@mail.gmail.com>
Subject: Manjaro Linux distro-specific hint for media-build
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi together, I just installed my new DVR-Card. Therefor I had to clone
the linuxtv.org/media_build.git and get a text for my distro. I can't
write a patch, but with this part of the log I think it will be easy
for you to extend the dependency-administration.

Greatings!

$ git clone git://linuxtv.org/media_build.git
Klone nach 'media_build' ...
remote: Counting objects: 2855, done.
remote: Compressing objects: 100% (1238/1238), done.
remote: Total 2855 (delta 2014), reused 2258 (delta 1577)
Empfange Objekte: 100% (2855/2855), 544.18 KiB | 972.00 KiB/s, Fertig.
Löse Unterschiede auf: 100% (2014/2014), Fertig.
Prüfe Konnektivität ... Fertig.
$ cd media_build
$ ./build
Checking if the needed tools for Manjaro Linux are available
ERROR: please install "lsdiff", otherwise, build won't work.
I don't know distro Manjaro Linux. So, I can't provide you a hint with
the package names.
Be welcome to contribute with a patch for media-build, by submitting a
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./build line 266.
$ yaourt -S lsdiff
Fehler: Ziel nicht gefunden: lsdiff
$ yaourt -S patchutils
Löse Abhängigkeiten auf...
Suche nach in Konflikt stehenden Paketen...

Pakete (1) patchutils-0.3.3-1

Gesamtgröße der zu installierenden Pakete:  0,16 MiB

:: Installation fortsetzen? [J/n]
(1/1) Prüfe Schlüssel im Schlüsselring

[########################################################] 100%
(1/1) Überprüfe Paket-Integrität

[########################################################] 100%
(1/1) Lade Paket-Dateien

[########################################################] 100%
(1/1) Prüfe auf Dateikonflikte

[########################################################] 100%
(1/1) Überprüfe verfügbaren Festplattenspeicher

[########################################################] 100%
(1/1) Installiere patchutils

[########################################################] 100%
$ ./build
Checking if the needed tools for Manjaro Linux are available
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort in the next 5 secs if you don't agree with  *
* the license                                              *
************************************************************

Not aborted. It means that the licence was agreed. Proceeding...
