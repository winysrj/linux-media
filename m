Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0KIRci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 12:32:38 -0500
Message-ID: <4CD985AF.4040706@redhat.com>
Date: Tue, 09 Nov 2010 15:32:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <4CD300AC.3010708@redhat.com> <1289079027-3037-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289079027-3037-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Arnaud,

Em 06-11-2010 19:30, Arnaud Lacombe escreveu:
> Hi,
> 
> This should do the job.
> 
> A.
> 
> Arnaud Lacombe (5):
>   kconfig: add an option to determine a menu's visibility
>   kconfig: regen parser
>   Revert "i2c: Fix Kconfig dependencies"
>   media/video: convert Kconfig to use the menu's `visible' keyword
>   i2c/algos: convert Kconfig to use the menu's `visible' keyword
> 
>  drivers/i2c/Kconfig                  |    3 +-
>  drivers/i2c/algos/Kconfig            |   14 +-
>  drivers/media/video/Kconfig          |    2 +-
>  scripts/kconfig/expr.h               |    1 +
>  scripts/kconfig/lkc.h                |    1 +
>  scripts/kconfig/menu.c               |   11 +
>  scripts/kconfig/zconf.gperf          |    1 +
>  scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
>  scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
>  scripts/kconfig/zconf.y              |   21 +-
>  10 files changed, 393 insertions(+), 353 deletions(-)

Patches look OK to my eyes. One more patch is needed, in order to fix build
warnings when customise is enabled for tuners and/or for DVB frontends.
I'm enclosing the fix.

For this patch series:
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Michal,

Would you apply those fixes to your tree, or do you prefer if I send them via
my tree?

Thanks,
Mauro

---


commit f53404d53c026548e03444f7ed33e8027716425d
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Tue Nov 9 15:29:05 2010 -0200

    [media] Fix Kconfig errors due to two visible menus
    
    Use the new visible Kconfig keyword to avoid producing error for two menus
    that are visible only if Tuner/frontend customise options are enabled.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 2385e6c..78b0895 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -31,7 +31,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
 
-menuconfig MEDIA_TUNER_CUSTOMISE
+config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
 	default y if EMBEDDED
@@ -44,7 +44,8 @@ menuconfig MEDIA_TUNER_CUSTOMISE
 
 	  If unsure say N.
 
-if MEDIA_TUNER_CUSTOMISE
+menu "Customize TV tuners"
+	visible if MEDIA_TUNER_CUSTOMISE
 
 config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
@@ -185,5 +186,4 @@ config MEDIA_TUNER_TDA18218
 	default m if MEDIA_TUNER_CUSTOMISE
 	help
 	  NXP TDA18218 silicon tuner driver.
-
-endif # MEDIA_TUNER_CUSTOMISE
+endmenu
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index e9062b0..96b2701 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -12,9 +12,8 @@ config DVB_FE_CUSTOMISE
 
 	  If unsure say N.
 
-if DVB_FE_CUSTOMISE
-
 menu "Customise DVB Frontends"
+	visible if DVB_FE_CUSTOMISE
 
 comment "Multistandard (satellite) frontends"
 	depends on DVB_CORE
@@ -619,5 +618,3 @@ config DVB_DUMMY_FE
 	tristate "Dummy frontend driver"
 	default n
 endmenu
-
-endif
