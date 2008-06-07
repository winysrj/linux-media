Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1K4wty-0006vX-Fo
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 13:48:07 +0200
Received: by fg-out-1718.google.com with SMTP id e21so978710fga.25
	for <linux-dvb@linuxtv.org>; Sat, 07 Jun 2008 04:48:03 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 7 Jun 2008 13:48:01 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806071348.01159.christophpfister@gmail.com>
Subject: [linux-dvb] Fwd: wrong dvb-t channel information in file
	"dvb-t/at-Official"
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

>From a kaffeine user ...

Christoph


----------  Weitergeleitete Nachricht  ----------

Betreff: [Bug 163374] New: wrong dvb-t channel information in 
file "dvb-t/at-Official"
Datum: Freitag 06 Juni 2008
Von: Daniel Blaschke <e9825797@stud3.tuwien.ac.at>
An: christophpfister@gmail.com

------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
         
http://bugs.kde.org/show_bug.cgi?id=163374         
           Summary: wrong dvb-t channel information in file "dvb-t/at-
                    Official"
           Product: kaffeine
           Version: unspecified
          Platform: Debian testing
        OS/Version: Linux
            Status: UNCONFIRMED
          Severity: normal
          Priority: NOR
         Component: general
        AssignedTo: hftom free fr
        ReportedBy: e9825797 stud3 tuwien ac at


Version:           0.8.6 (using KDE 3.5.9)
Installed from:    Debian testing/unstable Packages
OS:                Linux

In the file "dvb-t/at-Official" please change the line #14 from

T 578000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE

to

T 578000000 8MHz 3/4 NONE QAM16 8k 1/8 NONE

(1/8 instead of 1/4) since the channels transmitted in Vienna on that 
frequency (3SAT, Puls 4 and ORF Sport Plus) are not detected by kaffeine 
otherwise.

The line #6 with frequency 498000000 (ORF 1&2 and ATV) is correct with 
the "1/4". I live in Vienna and therefore haven't had the chance to check the 
other frequencies, i.e. those two are the only ones I get.

cheers, Daniel

-------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
