Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbGFNKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 09:10:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] Add new cities to Brazilian ISDB-T lists
Date: Mon,  6 Jul 2015 10:09:15 -0300
Message-Id: <1436188155-18875-4-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1436188155-18875-1-git-send-email-mchehab@osg.samsung.com>
References: <1436188155-18875-1-git-send-email-mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several new cities gained digital coverture. Add entries for
them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 isdb-t/br-al-MatrizDeCamaragibe     |  61 ++++++++++++++++++
 isdb-t/br-al-PalmeiraDosIndios      |  32 ++++++++++
 isdb-t/br-al-Penedo                 |  32 ++++++++++
 isdb-t/br-am-BocaDoAcre             |  32 ++++++++++
 isdb-t/br-am-Itacoatiara            |  32 ++++++++++
 isdb-t/br-ba-Seabra                 |  32 ++++++++++
 isdb-t/br-ce-Camocim                |  32 ++++++++++
 isdb-t/br-ce-Crateus                |  32 ++++++++++
 isdb-t/br-ce-Iguatu                 |  32 ++++++++++
 isdb-t/br-ce-Itapipoca              |  32 ++++++++++
 isdb-t/br-ce-Massape                |  32 ++++++++++
 isdb-t/br-ce-Russas                 |  32 ++++++++++
 isdb-t/br-es-Itapemirim             |  32 ++++++++++
 isdb-t/br-es-JoaoNeiva              |  32 ++++++++++
 isdb-t/br-es-Piuma                  |  32 ++++++++++
 isdb-t/br-es-VendaNovaDoImigrante   |  32 ++++++++++
 isdb-t/br-go-Minacu                 |  32 ++++++++++
 isdb-t/br-go-Morrinhos              |  32 ++++++++++
 isdb-t/br-go-Quirinopolis           |  32 ++++++++++
 isdb-t/br-go-Uruacu                 |  32 ++++++++++
 isdb-t/br-ma-SantaRita              | 119 ++++++++++++++++++++++++++++++++++++
 isdb-t/br-mg-Coromandel             |  32 ++++++++++
 isdb-t/br-mg-Iturama                |  32 ++++++++++
 isdb-t/br-mg-Lavras                 |  61 ++++++++++++++++++
 isdb-t/br-mg-PonteNova              |  32 ++++++++++
 isdb-t/br-mg-Sacramento             |  32 ++++++++++
 isdb-t/br-mg-SantaVitoria           |  32 ++++++++++
 isdb-t/br-ms-Amambai                |  32 ++++++++++
 isdb-t/br-pa-Tucurui                |  32 ++++++++++
 isdb-t/br-pe-Gravata                |  90 +++++++++++++++++++++++++++
 isdb-t/br-pi-Piripiri               |  32 ++++++++++
 isdb-t/br-pr-Araruna                |  32 ++++++++++
 isdb-t/br-pr-Medianeira             |  32 ++++++++++
 isdb-t/br-pr-Morretes               |  90 +++++++++++++++++++++++++++
 isdb-t/br-pr-Palmeira               |  32 ++++++++++
 isdb-t/br-pr-SantoAntonioDaPlatina  |  32 ++++++++++
 isdb-t/br-pr-SaoMiguelDoIguacu      |  32 ++++++++++
 isdb-t/br-pr-Tibagi                 |  32 ++++++++++
 isdb-t/br-rj-Cambuci                |  32 ++++++++++
 isdb-t/br-rj-Pirai                  |  32 ++++++++++
 isdb-t/br-rs-Ajuricaba              |  32 ++++++++++
 isdb-t/br-rs-FredericoWestphalen    |  32 ++++++++++
 isdb-t/br-rs-Garibaldi              |  32 ++++++++++
 isdb-t/br-rs-GetulioVargas          |  32 ++++++++++
 isdb-t/br-rs-HulhaNegra             |  32 ++++++++++
 isdb-t/br-rs-Itaqui                 |  61 ++++++++++++++++++
 isdb-t/br-sc-ChapadaoDoLageado      |  32 ++++++++++
 isdb-t/br-sc-Palmeira               |  32 ++++++++++
 isdb-t/br-se-CedroDeSaoJoao         |  32 ++++++++++
 isdb-t/br-sp-Adamantina             |  32 ++++++++++
 isdb-t/br-sp-AguasDaPrata           |  32 ++++++++++
 isdb-t/br-sp-AguasDeSantaBarbara    |  32 ++++++++++
 isdb-t/br-sp-Altinopolis            |  32 ++++++++++
 isdb-t/br-sp-Angatuba               |  32 ++++++++++
 isdb-t/br-sp-Avare                  |  32 ++++++++++
 isdb-t/br-sp-Barrinha               |  32 ++++++++++
 isdb-t/br-sp-Cananeia               |  61 ++++++++++++++++++
 isdb-t/br-sp-CesarioLange           |  90 +++++++++++++++++++++++++++
 isdb-t/br-sp-EspiritoSantoDoPinhal  |  32 ++++++++++
 isdb-t/br-sp-Iporanga               |  32 ++++++++++
 isdb-t/br-sp-Itapira                |  61 ++++++++++++++++++
 isdb-t/br-sp-Itarare                |  61 ++++++++++++++++++
 isdb-t/br-sp-Itariri                |  61 ++++++++++++++++++
 isdb-t/br-sp-Miracatu               |  32 ++++++++++
 isdb-t/br-sp-Olimpia                |  32 ++++++++++
 isdb-t/br-sp-OsvaldoCruz            |  32 ++++++++++
 isdb-t/br-sp-Pedreira               |  32 ++++++++++
 isdb-t/br-sp-PedroDeToledo          |  32 ++++++++++
 isdb-t/br-sp-PresidenteEpitacio     |  32 ++++++++++
 isdb-t/br-sp-SaoSebastiaoBoicucanga |  32 ++++++++++
 isdb-t/br-sp-SerraNegra             |  32 ++++++++++
 isdb-t/br-sp-Socorro                |  32 ++++++++++
 isdb-t/br-sp-TeodoroSampaio         |  32 ++++++++++
 isdb-t/br-sp-Tiete                  |  61 ++++++++++++++++++
 isdb-t/br-sp-VargemGrandeDoSul      |  61 ++++++++++++++++++
 75 files changed, 2922 insertions(+)
 create mode 100644 isdb-t/br-al-MatrizDeCamaragibe
 create mode 100644 isdb-t/br-al-PalmeiraDosIndios
 create mode 100644 isdb-t/br-al-Penedo
 create mode 100644 isdb-t/br-am-BocaDoAcre
 create mode 100644 isdb-t/br-am-Itacoatiara
 create mode 100644 isdb-t/br-ba-Seabra
 create mode 100644 isdb-t/br-ce-Camocim
 create mode 100644 isdb-t/br-ce-Crateus
 create mode 100644 isdb-t/br-ce-Iguatu
 create mode 100644 isdb-t/br-ce-Itapipoca
 create mode 100644 isdb-t/br-ce-Massape
 create mode 100644 isdb-t/br-ce-Russas
 create mode 100644 isdb-t/br-es-Itapemirim
 create mode 100644 isdb-t/br-es-JoaoNeiva
 create mode 100644 isdb-t/br-es-Piuma
 create mode 100644 isdb-t/br-es-VendaNovaDoImigrante
 create mode 100644 isdb-t/br-go-Minacu
 create mode 100644 isdb-t/br-go-Morrinhos
 create mode 100644 isdb-t/br-go-Quirinopolis
 create mode 100644 isdb-t/br-go-Uruacu
 create mode 100644 isdb-t/br-ma-SantaRita
 create mode 100644 isdb-t/br-mg-Coromandel
 create mode 100644 isdb-t/br-mg-Iturama
 create mode 100644 isdb-t/br-mg-Lavras
 create mode 100644 isdb-t/br-mg-PonteNova
 create mode 100644 isdb-t/br-mg-Sacramento
 create mode 100644 isdb-t/br-mg-SantaVitoria
 create mode 100644 isdb-t/br-ms-Amambai
 create mode 100644 isdb-t/br-pa-Tucurui
 create mode 100644 isdb-t/br-pe-Gravata
 create mode 100644 isdb-t/br-pi-Piripiri
 create mode 100644 isdb-t/br-pr-Araruna
 create mode 100644 isdb-t/br-pr-Medianeira
 create mode 100644 isdb-t/br-pr-Morretes
 create mode 100644 isdb-t/br-pr-Palmeira
 create mode 100644 isdb-t/br-pr-SantoAntonioDaPlatina
 create mode 100644 isdb-t/br-pr-SaoMiguelDoIguacu
 create mode 100644 isdb-t/br-pr-Tibagi
 create mode 100644 isdb-t/br-rj-Cambuci
 create mode 100644 isdb-t/br-rj-Pirai
 create mode 100644 isdb-t/br-rs-Ajuricaba
 create mode 100644 isdb-t/br-rs-FredericoWestphalen
 create mode 100644 isdb-t/br-rs-Garibaldi
 create mode 100644 isdb-t/br-rs-GetulioVargas
 create mode 100644 isdb-t/br-rs-HulhaNegra
 create mode 100644 isdb-t/br-rs-Itaqui
 create mode 100644 isdb-t/br-sc-ChapadaoDoLageado
 create mode 100644 isdb-t/br-sc-Palmeira
 create mode 100644 isdb-t/br-se-CedroDeSaoJoao
 create mode 100644 isdb-t/br-sp-Adamantina
 create mode 100644 isdb-t/br-sp-AguasDaPrata
 create mode 100644 isdb-t/br-sp-AguasDeSantaBarbara
 create mode 100644 isdb-t/br-sp-Altinopolis
 create mode 100644 isdb-t/br-sp-Angatuba
 create mode 100644 isdb-t/br-sp-Avare
 create mode 100644 isdb-t/br-sp-Barrinha
 create mode 100644 isdb-t/br-sp-Cananeia
 create mode 100644 isdb-t/br-sp-CesarioLange
 create mode 100644 isdb-t/br-sp-EspiritoSantoDoPinhal
 create mode 100644 isdb-t/br-sp-Iporanga
 create mode 100644 isdb-t/br-sp-Itapira
 create mode 100644 isdb-t/br-sp-Itarare
 create mode 100644 isdb-t/br-sp-Itariri
 create mode 100644 isdb-t/br-sp-Miracatu
 create mode 100644 isdb-t/br-sp-Olimpia
 create mode 100644 isdb-t/br-sp-OsvaldoCruz
 create mode 100644 isdb-t/br-sp-Pedreira
 create mode 100644 isdb-t/br-sp-PedroDeToledo
 create mode 100644 isdb-t/br-sp-PresidenteEpitacio
 create mode 100644 isdb-t/br-sp-SaoSebastiaoBoicucanga
 create mode 100644 isdb-t/br-sp-SerraNegra
 create mode 100644 isdb-t/br-sp-Socorro
 create mode 100644 isdb-t/br-sp-TeodoroSampaio
 create mode 100644 isdb-t/br-sp-Tiete
 create mode 100644 isdb-t/br-sp-VargemGrandeDoSul

diff --git a/isdb-t/br-al-MatrizDeCamaragibe b/isdb-t/br-al-MatrizDeCamaragibe
new file mode 100644
index 000000000000..d89e16f8016e
--- /dev/null
+++ b/isdb-t/br-al-MatrizDeCamaragibe
@@ -0,0 +1,61 @@
+# Channel table for Matriz de Camaragibe - AL - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1264
+
+# Physical channel 28
+[SBT]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 557142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 40
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 629142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-al-PalmeiraDosIndios b/isdb-t/br-al-PalmeiraDosIndios
new file mode 100644
index 000000000000..a87904c6c8ae
--- /dev/null
+++ b/isdb-t/br-al-PalmeiraDosIndios
@@ -0,0 +1,32 @@
+# Channel table for Palmeira dos Índios - AL - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1004
+
+# Physical channel 49
+[RIT]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 683142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-al-Penedo b/isdb-t/br-al-Penedo
new file mode 100644
index 000000000000..3f8ac9d26836
--- /dev/null
+++ b/isdb-t/br-al-Penedo
@@ -0,0 +1,32 @@
+# Channel table for Penedo - AL - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=555
+
+# Physical channel 26
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-am-BocaDoAcre b/isdb-t/br-am-BocaDoAcre
new file mode 100644
index 000000000000..886f879195d9
--- /dev/null
+++ b/isdb-t/br-am-BocaDoAcre
@@ -0,0 +1,32 @@
+# Channel table for Boca do Acre - AM - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1407
+
+# Physical channel 40
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 629142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-am-Itacoatiara b/isdb-t/br-am-Itacoatiara
new file mode 100644
index 000000000000..8532e0865aac
--- /dev/null
+++ b/isdb-t/br-am-Itacoatiara
@@ -0,0 +1,32 @@
+# Channel table for Itacoatiara - AM - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=332
+
+# Physical channel 16
+[TV Itacoatiara]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 485142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ba-Seabra b/isdb-t/br-ba-Seabra
new file mode 100644
index 000000000000..a63384de9b43
--- /dev/null
+++ b/isdb-t/br-ba-Seabra
@@ -0,0 +1,32 @@
+# Channel table for Seabra - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=805
+
+# Physical channel 29
+[TV Bahia]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 563142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Camocim b/isdb-t/br-ce-Camocim
new file mode 100644
index 000000000000..9d017b035e6d
--- /dev/null
+++ b/isdb-t/br-ce-Camocim
@@ -0,0 +1,32 @@
+# Channel table for Camocim - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=545
+
+# Physical channel 33
+[TV Verdes Mares]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 587142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Crateus b/isdb-t/br-ce-Crateus
new file mode 100644
index 000000000000..d06a032e7223
--- /dev/null
+++ b/isdb-t/br-ce-Crateus
@@ -0,0 +1,32 @@
+# Channel table for Crateús - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=506
+
+# Physical channel 16
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 485142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Iguatu b/isdb-t/br-ce-Iguatu
new file mode 100644
index 000000000000..207cd666b948
--- /dev/null
+++ b/isdb-t/br-ce-Iguatu
@@ -0,0 +1,32 @@
+# Channel table for Iguatu - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=314
+
+# Physical channel 32
+[TV Verdes Mares Cariri]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 581142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Itapipoca b/isdb-t/br-ce-Itapipoca
new file mode 100644
index 000000000000..2f713638ad40
--- /dev/null
+++ b/isdb-t/br-ce-Itapipoca
@@ -0,0 +1,32 @@
+# Channel table for Itapipoca - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=547
+
+# Physical channel 33
+[TV Verdes Mares]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 587142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Massape b/isdb-t/br-ce-Massape
new file mode 100644
index 000000000000..72e1dd80732b
--- /dev/null
+++ b/isdb-t/br-ce-Massape
@@ -0,0 +1,32 @@
+# Channel table for Massapê - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1019
+
+# Physical channel 39
+[NordesTV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 623142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ce-Russas b/isdb-t/br-ce-Russas
new file mode 100644
index 000000000000..2c265b7d9235
--- /dev/null
+++ b/isdb-t/br-ce-Russas
@@ -0,0 +1,32 @@
+# Channel table for Russas - CE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1646
+
+# Physical channel 40
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 629142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-es-Itapemirim b/isdb-t/br-es-Itapemirim
new file mode 100644
index 000000000000..560c0bfd2cee
--- /dev/null
+++ b/isdb-t/br-es-Itapemirim
@@ -0,0 +1,32 @@
+# Channel table for Itapemirim - ES - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1524
+
+# Physical channel 24
+[TV Gazeta Sul]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 533142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-es-JoaoNeiva b/isdb-t/br-es-JoaoNeiva
new file mode 100644
index 000000000000..7b61cdea889e
--- /dev/null
+++ b/isdb-t/br-es-JoaoNeiva
@@ -0,0 +1,32 @@
+# Channel table for João Neiva - ES - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1408
+
+# Physical channel 23
+[TV Gazeta Norte]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 527142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-es-Piuma b/isdb-t/br-es-Piuma
new file mode 100644
index 000000000000..ed9956b0a5dd
--- /dev/null
+++ b/isdb-t/br-es-Piuma
@@ -0,0 +1,32 @@
+# Channel table for Piúma - ES - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1523
+
+# Physical channel 21
+[TV Gazeta Sul]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 515142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-es-VendaNovaDoImigrante b/isdb-t/br-es-VendaNovaDoImigrante
new file mode 100644
index 000000000000..2c9ca0ae3db3
--- /dev/null
+++ b/isdb-t/br-es-VendaNovaDoImigrante
@@ -0,0 +1,32 @@
+# Channel table for Venda Nova do Imigrante - ES - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=657
+
+# Physical channel 22
+[TV Gazeta Vitória]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 521142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-go-Minacu b/isdb-t/br-go-Minacu
new file mode 100644
index 000000000000..fd92eb747415
--- /dev/null
+++ b/isdb-t/br-go-Minacu
@@ -0,0 +1,32 @@
+# Channel table for Minaçu - GO - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=966
+
+# Physical channel 25
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 539142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-go-Morrinhos b/isdb-t/br-go-Morrinhos
new file mode 100644
index 000000000000..5b11b620577e
--- /dev/null
+++ b/isdb-t/br-go-Morrinhos
@@ -0,0 +1,32 @@
+# Channel table for Morrinhos - GO - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=429
+
+# Physical channel 58
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 737142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-go-Quirinopolis b/isdb-t/br-go-Quirinopolis
new file mode 100644
index 000000000000..1261fc4c4bd6
--- /dev/null
+++ b/isdb-t/br-go-Quirinopolis
@@ -0,0 +1,32 @@
+# Channel table for Quirinópolis - GO - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=571
+
+# Physical channel 49
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 683142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-go-Uruacu b/isdb-t/br-go-Uruacu
new file mode 100644
index 000000000000..8377fbb70538
--- /dev/null
+++ b/isdb-t/br-go-Uruacu
@@ -0,0 +1,32 @@
+# Channel table for Uruaçu - GO - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=426
+
+# Physical channel 25
+[TV Canção Nova]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 539142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ma-SantaRita b/isdb-t/br-ma-SantaRita
new file mode 100644
index 000000000000..11195fa51e5d
--- /dev/null
+++ b/isdb-t/br-ma-SantaRita
@@ -0,0 +1,119 @@
+# Channel table for Santa Rita - MA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=465
+
+# Physical channel 22
+[TV Guará]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 521142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 29
+[TV Mirante]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 563142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 36
+[TV Cidade/MA]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 605142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 38
+[TV Difusora]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 617142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-Coromandel b/isdb-t/br-mg-Coromandel
new file mode 100644
index 000000000000..018948b6a02b
--- /dev/null
+++ b/isdb-t/br-mg-Coromandel
@@ -0,0 +1,32 @@
+# Channel table for Coromandel - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1007
+
+# Physical channel 29
+[TV Paranaíba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 563142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-Iturama b/isdb-t/br-mg-Iturama
new file mode 100644
index 000000000000..87c38cd96955
--- /dev/null
+++ b/isdb-t/br-mg-Iturama
@@ -0,0 +1,32 @@
+# Channel table for Iturama - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=575
+
+# Physical channel 28
+[TV Paranaíba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 557142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-Lavras b/isdb-t/br-mg-Lavras
new file mode 100644
index 000000000000..1d221b5137bc
--- /dev/null
+++ b/isdb-t/br-mg-Lavras
@@ -0,0 +1,61 @@
+# Channel table for Lavras - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=64
+
+# Physical channel 23
+[TV Alterosa]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 527142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 40
+[TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 629142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-PonteNova b/isdb-t/br-mg-PonteNova
new file mode 100644
index 000000000000..bd3cf1f931b0
--- /dev/null
+++ b/isdb-t/br-mg-PonteNova
@@ -0,0 +1,32 @@
+# Channel table for Ponte Nova - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=135
+
+# Physical channel 33
+[Globo Minas]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 587142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-Sacramento b/isdb-t/br-mg-Sacramento
new file mode 100644
index 000000000000..17a02cc0540d
--- /dev/null
+++ b/isdb-t/br-mg-Sacramento
@@ -0,0 +1,32 @@
+# Channel table for Sacramento - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=877
+
+# Physical channel 28
+[TV Paranaíba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 557142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-mg-SantaVitoria b/isdb-t/br-mg-SantaVitoria
new file mode 100644
index 000000000000..ebe0740fb21d
--- /dev/null
+++ b/isdb-t/br-mg-SantaVitoria
@@ -0,0 +1,32 @@
+# Channel table for Santa Vitória - MG - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=569
+
+# Physical channel 28
+[TV Paranaíba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 557142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-ms-Amambai b/isdb-t/br-ms-Amambai
new file mode 100644
index 000000000000..0a1242cd9109
--- /dev/null
+++ b/isdb-t/br-ms-Amambai
@@ -0,0 +1,32 @@
+# Channel table for Amambaí - MS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=844
+
+# Physical channel 30
+[TV Morena]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 569142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pa-Tucurui b/isdb-t/br-pa-Tucurui
new file mode 100644
index 000000000000..730472020b39
--- /dev/null
+++ b/isdb-t/br-pa-Tucurui
@@ -0,0 +1,32 @@
+# Channel table for Tucuruí - PA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=581
+
+# Physical channel 27
+[TV Floresta]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 551142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pe-Gravata b/isdb-t/br-pe-Gravata
new file mode 100644
index 000000000000..88b9449037e9
--- /dev/null
+++ b/isdb-t/br-pe-Gravata
@@ -0,0 +1,90 @@
+# Channel table for Gravatá - PE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=243
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 17
+[TV Asa Branca]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 491142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 36
+[Globo Nordeste]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 605142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pi-Piripiri b/isdb-t/br-pi-Piripiri
new file mode 100644
index 000000000000..a3263294669b
--- /dev/null
+++ b/isdb-t/br-pi-Piripiri
@@ -0,0 +1,32 @@
+# Channel table for Piripiri - PI - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=191
+
+# Physical channel 18
+[TV Cidade Verde]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 497142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-Araruna b/isdb-t/br-pr-Araruna
new file mode 100644
index 000000000000..e808578132cf
--- /dev/null
+++ b/isdb-t/br-pr-Araruna
@@ -0,0 +1,32 @@
+# Channel table for Araruna - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1765
+
+# Physical channel 21
+[TV Tibagi]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 515142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-Medianeira b/isdb-t/br-pr-Medianeira
new file mode 100644
index 000000000000..a3228e60fc1d
--- /dev/null
+++ b/isdb-t/br-pr-Medianeira
@@ -0,0 +1,32 @@
+# Channel table for Medianeira - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=182
+
+# Physical channel 26
+[RIC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-Morretes b/isdb-t/br-pr-Morretes
new file mode 100644
index 000000000000..7a73973fe597
--- /dev/null
+++ b/isdb-t/br-pr-Morretes
@@ -0,0 +1,90 @@
+# Channel table for Morretes - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1676
+
+# Physical channel 15
+[TVCI]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 39
+[TV Iguaçu]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 623142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 41
+[RPC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 635142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-Palmeira b/isdb-t/br-pr-Palmeira
new file mode 100644
index 000000000000..63769403e939
--- /dev/null
+++ b/isdb-t/br-pr-Palmeira
@@ -0,0 +1,32 @@
+# Channel table for Palmeira - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1709
+
+# Physical channel 29
+[RPC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 563142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-SantoAntonioDaPlatina b/isdb-t/br-pr-SantoAntonioDaPlatina
new file mode 100644
index 000000000000..d76448fc4a9d
--- /dev/null
+++ b/isdb-t/br-pr-SantoAntonioDaPlatina
@@ -0,0 +1,32 @@
+# Channel table for Santo Antonio da Platina - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=433
+
+# Physical channel 34
+[RIC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 593142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-SaoMiguelDoIguacu b/isdb-t/br-pr-SaoMiguelDoIguacu
new file mode 100644
index 000000000000..c62dc5df92b5
--- /dev/null
+++ b/isdb-t/br-pr-SaoMiguelDoIguacu
@@ -0,0 +1,32 @@
+# Channel table for São Miguel do Iguaçu - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=269
+
+# Physical channel 50
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 689142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-pr-Tibagi b/isdb-t/br-pr-Tibagi
new file mode 100644
index 000000000000..b6e228d688f8
--- /dev/null
+++ b/isdb-t/br-pr-Tibagi
@@ -0,0 +1,32 @@
+# Channel table for Tibagi - PR - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=78
+
+# Physical channel 42
+[RPC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 641142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rj-Cambuci b/isdb-t/br-rj-Cambuci
new file mode 100644
index 000000000000..bcda0cd4c760
--- /dev/null
+++ b/isdb-t/br-rj-Cambuci
@@ -0,0 +1,32 @@
+# Channel table for Cambuci - RJ - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=906
+
+# Physical channel 24
+[SBT Interior/RJ]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 533142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rj-Pirai b/isdb-t/br-rj-Pirai
new file mode 100644
index 000000000000..bc9ebb9f86f6
--- /dev/null
+++ b/isdb-t/br-rj-Pirai
@@ -0,0 +1,32 @@
+# Channel table for Piraí - RJ - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=904
+
+# Physical channel 23
+[SBT Interior/RJ]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 527142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-Ajuricaba b/isdb-t/br-rs-Ajuricaba
new file mode 100644
index 000000000000..86d5d99ee9fa
--- /dev/null
+++ b/isdb-t/br-rs-Ajuricaba
@@ -0,0 +1,32 @@
+# Channel table for Ajuricaba - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1839
+
+# Physical channel 35
+[RBS TV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 599142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-FredericoWestphalen b/isdb-t/br-rs-FredericoWestphalen
new file mode 100644
index 000000000000..d742b4a12baa
--- /dev/null
+++ b/isdb-t/br-rs-FredericoWestphalen
@@ -0,0 +1,32 @@
+# Channel table for Frederico Westphalen - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1982
+
+# Physical channel 18
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 497142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-Garibaldi b/isdb-t/br-rs-Garibaldi
new file mode 100644
index 000000000000..1d6ec3a79fa8
--- /dev/null
+++ b/isdb-t/br-rs-Garibaldi
@@ -0,0 +1,32 @@
+# Channel table for Garibaldi - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1629
+
+# Physical channel 35
+[RBS TV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 599142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-GetulioVargas b/isdb-t/br-rs-GetulioVargas
new file mode 100644
index 000000000000..ec0ab024e412
--- /dev/null
+++ b/isdb-t/br-rs-GetulioVargas
@@ -0,0 +1,32 @@
+# Channel table for Getúlio Vargas - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1984
+
+# Physical channel 17
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 491142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-HulhaNegra b/isdb-t/br-rs-HulhaNegra
new file mode 100644
index 000000000000..d0ba8ea1d59a
--- /dev/null
+++ b/isdb-t/br-rs-HulhaNegra
@@ -0,0 +1,32 @@
+# Channel table for Hulha Negra - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1954
+
+# Physical channel 34
+[RBS TV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 593142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-rs-Itaqui b/isdb-t/br-rs-Itaqui
new file mode 100644
index 000000000000..0698eef659e8
--- /dev/null
+++ b/isdb-t/br-rs-Itaqui
@@ -0,0 +1,61 @@
+# Channel table for Itaqui - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=685
+
+# Physical channel 28
+[TVE RS]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 557142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 33
+[RBS TV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 587142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sc-ChapadaoDoLageado b/isdb-t/br-sc-ChapadaoDoLageado
new file mode 100644
index 000000000000..068d74a04653
--- /dev/null
+++ b/isdb-t/br-sc-ChapadaoDoLageado
@@ -0,0 +1,32 @@
+# Channel table for Chapadão do Lageado - SC - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1829
+
+# Physical channel 34
+[RBS SC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 593142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sc-Palmeira b/isdb-t/br-sc-Palmeira
new file mode 100644
index 000000000000..88c901498a06
--- /dev/null
+++ b/isdb-t/br-sc-Palmeira
@@ -0,0 +1,32 @@
+# Channel table for Palmeira - SC - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1834
+
+# Physical channel 34
+[RBS SC]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 593142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-se-CedroDeSaoJoao b/isdb-t/br-se-CedroDeSaoJoao
new file mode 100644
index 000000000000..494b3cd1fad6
--- /dev/null
+++ b/isdb-t/br-se-CedroDeSaoJoao
@@ -0,0 +1,32 @@
+# Channel table for Cedro de São João - SE - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=289
+
+# Physical channel 16
+[Rede Século 21]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 485142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Adamantina b/isdb-t/br-sp-Adamantina
new file mode 100644
index 000000000000..4da7a34ab218
--- /dev/null
+++ b/isdb-t/br-sp-Adamantina
@@ -0,0 +1,32 @@
+# Channel table for Adamantina - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=507
+
+# Physical channel 16
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 485142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-AguasDaPrata b/isdb-t/br-sp-AguasDaPrata
new file mode 100644
index 000000000000..a9598749e1fb
--- /dev/null
+++ b/isdb-t/br-sp-AguasDaPrata
@@ -0,0 +1,32 @@
+# Channel table for Águas da Prata - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=855
+
+# Physical channel 24
+[SBT Ribeirão Preto]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 533142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-AguasDeSantaBarbara b/isdb-t/br-sp-AguasDeSantaBarbara
new file mode 100644
index 000000000000..45c115c63e34
--- /dev/null
+++ b/isdb-t/br-sp-AguasDeSantaBarbara
@@ -0,0 +1,32 @@
+# Channel table for Águas de Santa Bárbara - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=885
+
+# Physical channel 26
+[TV Tem Itapetininga]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Altinopolis b/isdb-t/br-sp-Altinopolis
new file mode 100644
index 000000000000..0fb55b37c46e
--- /dev/null
+++ b/isdb-t/br-sp-Altinopolis
@@ -0,0 +1,32 @@
+# Channel table for Altinópolis - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1387
+
+# Physical channel 39
+[SBT Ribeirão Preto]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 623142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Angatuba b/isdb-t/br-sp-Angatuba
new file mode 100644
index 000000000000..41182e7b7c8c
--- /dev/null
+++ b/isdb-t/br-sp-Angatuba
@@ -0,0 +1,32 @@
+# Channel table for Angatuba - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=980
+
+# Physical channel 35
+[TV Sorocaba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 599142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Avare b/isdb-t/br-sp-Avare
new file mode 100644
index 000000000000..6563bc4f0e4d
--- /dev/null
+++ b/isdb-t/br-sp-Avare
@@ -0,0 +1,32 @@
+# Channel table for Avaré - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1768
+
+# Physical channel 20
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 509142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Barrinha b/isdb-t/br-sp-Barrinha
new file mode 100644
index 000000000000..a9c0a4e678f6
--- /dev/null
+++ b/isdb-t/br-sp-Barrinha
@@ -0,0 +1,32 @@
+# Channel table for Barrinha - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=867
+
+# Physical channel 42
+[EPTV Ribeirão]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 641142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Cananeia b/isdb-t/br-sp-Cananeia
new file mode 100644
index 000000000000..6e6932a47a3b
--- /dev/null
+++ b/isdb-t/br-sp-Cananeia
@@ -0,0 +1,61 @@
+# Channel table for Cananeia - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=440
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 19
+[TV Tribuna]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 503142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-CesarioLange b/isdb-t/br-sp-CesarioLange
new file mode 100644
index 000000000000..751e250d510a
--- /dev/null
+++ b/isdb-t/br-sp-CesarioLange
@@ -0,0 +1,90 @@
+# Channel table for Cesário Lange - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=4
+
+# Physical channel 23
+[Band]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 527142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 26
+[TV Tem Itapetininga]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 32
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 581142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-EspiritoSantoDoPinhal b/isdb-t/br-sp-EspiritoSantoDoPinhal
new file mode 100644
index 000000000000..52fc4d71d262
--- /dev/null
+++ b/isdb-t/br-sp-EspiritoSantoDoPinhal
@@ -0,0 +1,32 @@
+# Channel table for Espírito Santo do Pinhal - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=977
+
+# Physical channel 30
+[VTV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 569142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Iporanga b/isdb-t/br-sp-Iporanga
new file mode 100644
index 000000000000..b4aa55903482
--- /dev/null
+++ b/isdb-t/br-sp-Iporanga
@@ -0,0 +1,32 @@
+# Channel table for Iporanga - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=446
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Itapira b/isdb-t/br-sp-Itapira
new file mode 100644
index 000000000000..9686666bcec8
--- /dev/null
+++ b/isdb-t/br-sp-Itapira
@@ -0,0 +1,61 @@
+# Channel table for Itapira - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=394
+
+# Physical channel 30
+[VTV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 569142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 42
+[EPTV Campinas]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 641142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Itarare b/isdb-t/br-sp-Itarare
new file mode 100644
index 000000000000..e14b23c88296
--- /dev/null
+++ b/isdb-t/br-sp-Itarare
@@ -0,0 +1,61 @@
+# Channel table for Itararé - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=460
+
+# Physical channel 20
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 509142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 26
+[TV Tem Itapetininga]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Itariri b/isdb-t/br-sp-Itariri
new file mode 100644
index 000000000000..a3900b91c7e5
--- /dev/null
+++ b/isdb-t/br-sp-Itariri
@@ -0,0 +1,61 @@
+# Channel table for Itariri - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=451
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 19
+[TV Tribuna]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 503142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Miracatu b/isdb-t/br-sp-Miracatu
new file mode 100644
index 000000000000..535a45acff30
--- /dev/null
+++ b/isdb-t/br-sp-Miracatu
@@ -0,0 +1,32 @@
+# Channel table for Miracatu - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=453
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Olimpia b/isdb-t/br-sp-Olimpia
new file mode 100644
index 000000000000..03227e76822e
--- /dev/null
+++ b/isdb-t/br-sp-Olimpia
@@ -0,0 +1,32 @@
+# Channel table for Olímpia - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=778
+
+# Physical channel 32
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 581142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-OsvaldoCruz b/isdb-t/br-sp-OsvaldoCruz
new file mode 100644
index 000000000000..0a595df51d5e
--- /dev/null
+++ b/isdb-t/br-sp-OsvaldoCruz
@@ -0,0 +1,32 @@
+# Channel table for Osvaldo Cruz - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1446
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Pedreira b/isdb-t/br-sp-Pedreira
new file mode 100644
index 000000000000..a395918310d2
--- /dev/null
+++ b/isdb-t/br-sp-Pedreira
@@ -0,0 +1,32 @@
+# Channel table for Pedreira - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=141
+
+# Physical channel 30
+[VTV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 569142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-PedroDeToledo b/isdb-t/br-sp-PedroDeToledo
new file mode 100644
index 000000000000..8b263508d3ac
--- /dev/null
+++ b/isdb-t/br-sp-PedroDeToledo
@@ -0,0 +1,32 @@
+# Channel table for Pedro de Toledo - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=456
+
+# Physical channel 19
+[TV Tribuna]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 503142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-PresidenteEpitacio b/isdb-t/br-sp-PresidenteEpitacio
new file mode 100644
index 000000000000..f897b394a5d2
--- /dev/null
+++ b/isdb-t/br-sp-PresidenteEpitacio
@@ -0,0 +1,32 @@
+# Channel table for Presidente Epitácio - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=983
+
+# Physical channel 15
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 479142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-SaoSebastiaoBoicucanga b/isdb-t/br-sp-SaoSebastiaoBoicucanga
new file mode 100644
index 000000000000..0704d1ec829b
--- /dev/null
+++ b/isdb-t/br-sp-SaoSebastiaoBoicucanga
@@ -0,0 +1,32 @@
+# Channel table for São Sebastião (Boiçucanga) - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=894
+
+# Physical channel 25
+[Band Vale]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 539142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-SerraNegra b/isdb-t/br-sp-SerraNegra
new file mode 100644
index 000000000000..201a66613f67
--- /dev/null
+++ b/isdb-t/br-sp-SerraNegra
@@ -0,0 +1,32 @@
+# Channel table for Serra Negra - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=105
+
+# Physical channel 30
+[VTV]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 569142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Socorro b/isdb-t/br-sp-Socorro
new file mode 100644
index 000000000000..f2805e3d78f3
--- /dev/null
+++ b/isdb-t/br-sp-Socorro
@@ -0,0 +1,32 @@
+# Channel table for Socorro - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=768
+
+# Physical channel 32
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 581142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-TeodoroSampaio b/isdb-t/br-sp-TeodoroSampaio
new file mode 100644
index 000000000000..d845ce01273c
--- /dev/null
+++ b/isdb-t/br-sp-TeodoroSampaio
@@ -0,0 +1,32 @@
+# Channel table for Teodoro Sampaio - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=981
+
+# Physical channel 33
+[SBT Interior/SP]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 587142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-Tiete b/isdb-t/br-sp-Tiete
new file mode 100644
index 000000000000..8126f82928a0
--- /dev/null
+++ b/isdb-t/br-sp-Tiete
@@ -0,0 +1,61 @@
+# Channel table for Tietê - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=952
+
+# Physical channel 32
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 581142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 35
+[TV Sorocaba]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 599142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
diff --git a/isdb-t/br-sp-VargemGrandeDoSul b/isdb-t/br-sp-VargemGrandeDoSul
new file mode 100644
index 000000000000..6361c965cae9
--- /dev/null
+++ b/isdb-t/br-sp-VargemGrandeDoSul
@@ -0,0 +1,61 @@
+# Channel table for Vargem Grande do Sul - SP - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=774
+
+# Physical channel 26
+[EPTV Central]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 545142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
+# Physical channel 46
+[Record Interior]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 665142857
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	INVERSION = AUTO
+	GUARD_INTERVAL = AUTO
+	TRANSMISSION_MODE = AUTO
+	ISDBT_LAYER_ENABLED = 7
+	ISDBT_SOUND_BROADCASTING = 0
+	ISDBT_SB_SUBCHANNEL_ID = 0
+	ISDBT_SB_SEGMENT_IDX = 0
+	ISDBT_SB_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_FEC = AUTO
+	ISDBT_LAYERA_MODULATION = QAM/AUTO
+	ISDBT_LAYERA_SEGMENT_COUNT = 0
+	ISDBT_LAYERA_TIME_INTERLEAVING = 0
+	ISDBT_LAYERB_FEC = AUTO
+	ISDBT_LAYERB_MODULATION = QAM/AUTO
+	ISDBT_LAYERB_SEGMENT_COUNT = 0
+	ISDBT_LAYERB_TIME_INTERLEAVING = 0
+	ISDBT_LAYERC_FEC = AUTO
+	ISDBT_LAYERC_MODULATION = QAM/AUTO
+	ISDBT_LAYERC_SEGMENT_COUNT = 0
+	ISDBT_LAYERC_TIME_INTERLEAVING = 0
+
-- 
2.4.3

