Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:33103 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0FXGdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 02:33:20 -0400
Received: by fg-out-1718.google.com with SMTP id l26so589572fgb.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jun 2010 23:33:19 -0700 (PDT)
MIME-Version: 1.0
Reply-To: debarshi.ray@gmail.com
Date: Thu, 24 Jun 2010 09:33:18 +0300
Message-ID: <AANLkTikiNKl-Np2EqhVw4JfpgScA4HZFvUz_W1Qrh-KE@mail.gmail.com>
Subject: IR port on TechniSat CableStar HD 2
From: Debarshi Ray <debarshi.ray@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I read [1] that you were working on adding support for the IR port on
the TechniSat CableStar HD 2 card. However, when I tried to compile
the drivers from http://linuxtv.org/hg/v4l-dvb as instructed on
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers#If_the_Modules_did_not_load_correctly_or_the_device_is_still_not_configured_correctly_for_use
it did not work. The device is not listed in /proc/bus/input/devices

I am using Debian testing which has the 2.6.32 kernel and here are
some of the modules I have loaded:

bob@bob:~$ lsmod | grep mantis
mantis                 14872  0
mantis_core            23989  6 mantis
ir_common               3621  1 mantis_core
ir_core                10193  7
ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,mantis_core,ir_nec_decoder,ir_common
tda665x                 2679  1 mantis
lnbp21                  1740  1 mantis
mb86a16                16566  1 mantis
stb6100                 5525  1 mantis
tda10021                4774  1 mantis
tda10023                5823  1 mantis
zl10353                 5861  1 mantis
stb0899                28713  1 mantis
stv0299                 7812  1 mantis
dvb_core               74866  3 b2c2_flexcop,mantis_core,stv0299
i2c_core               15712  20
b2c2_flexcop,cx24123,cx24113,s5h1420,mantis,mantis_core,tda665x,lnbp21,mb86a16,stb6100,tda10021,tda10023,zl10353,stb0899,stv0299,nouveau,drm_kms_helper,drm,i2c_algo_bit,i2c_nforce2

I also tried to build the drivers from
http://jusst.de/hg/mantis-v4l-dvb/ but the build failed.

Could you please let me know what is the current status?

Thanks,
Debarshi


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg14620.html
