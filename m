Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaE0QwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 12:52:00 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/12] Add Brazil's Rio Grande do Sul state tables
Date: Tue, 27 May 2014 13:50:24 -0300
Message-Id: <1401209432-7327-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
References: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 dvbv5_isdb-t/br-rs-Alegrete               |  61 +++++++
 dvbv5_isdb-t/br-rs-ArroioDoSal            |  90 ++++++++++
 dvbv5_isdb-t/br-rs-Bage                   |  61 +++++++
 dvbv5_isdb-t/br-rs-BentoGoncalves         |  32 ++++
 dvbv5_isdb-t/br-rs-CachoeiraDoSul         |  61 +++++++
 dvbv5_isdb-t/br-rs-Camaqua                |  32 ++++
 dvbv5_isdb-t/br-rs-CampoBom               | 206 +++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-Candelaria             |  61 +++++++
 dvbv5_isdb-t/br-rs-Canela                 |  32 ++++
 dvbv5_isdb-t/br-rs-Cangucu                |  32 ++++
 dvbv5_isdb-t/br-rs-CapaoDaCanoa           |  32 ++++
 dvbv5_isdb-t/br-rs-CapaoDoLeao            |  32 ++++
 dvbv5_isdb-t/br-rs-Carazinho              |  32 ++++
 dvbv5_isdb-t/br-rs-CarlosBarbosa          |  32 ++++
 dvbv5_isdb-t/br-rs-CaxiasDoSul            |  61 +++++++
 dvbv5_isdb-t/br-rs-Cidreira               |  61 +++++++
 dvbv5_isdb-t/br-rs-CruzAlta               |  32 ++++
 dvbv5_isdb-t/br-rs-DomPedroDeAlcantara    |  32 ++++
 dvbv5_isdb-t/br-rs-Erechim                |  61 +++++++
 dvbv5_isdb-t/br-rs-Estrela                |  32 ++++
 dvbv5_isdb-t/br-rs-Farroupilha            |  61 +++++++
 dvbv5_isdb-t/br-rs-Feliz                  |  32 ++++
 dvbv5_isdb-t/br-rs-FloresDaCunha          |  32 ++++
 dvbv5_isdb-t/br-rs-Gramado                |  32 ++++
 dvbv5_isdb-t/br-rs-Ijui                   |  32 ++++
 dvbv5_isdb-t/br-rs-Lajeado                |  32 ++++
 dvbv5_isdb-t/br-rs-MonteAlegreDosCampos   |  61 +++++++
 dvbv5_isdb-t/br-rs-Montenegro             | 235 ++++++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-MorroRedondo           |  32 ++++
 dvbv5_isdb-t/br-rs-NovaPetropolis         |  32 ++++
 dvbv5_isdb-t/br-rs-NovaSantaRita          | 206 +++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-NovoHamburgo           | 264 ++++++++++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-Osorio                 | 148 +++++++++++++++++
 dvbv5_isdb-t/br-rs-PalmaresDoSul          |  32 ++++
 dvbv5_isdb-t/br-rs-ParaisoDoSul           |  32 ++++
 dvbv5_isdb-t/br-rs-PassoFundo             |  61 +++++++
 dvbv5_isdb-t/br-rs-Pelotas                |  61 +++++++
 dvbv5_isdb-t/br-rs-PicadaCafe             |  32 ++++
 dvbv5_isdb-t/br-rs-PortoAlegre            | 264 ++++++++++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-RioGrande              |  61 +++++++
 dvbv5_isdb-t/br-rs-RioGrandeCassino       |  32 ++++
 dvbv5_isdb-t/br-rs-SalvadorDoSul          | 148 +++++++++++++++++
 dvbv5_isdb-t/br-rs-Sananduva              |  32 ++++
 dvbv5_isdb-t/br-rs-SantaCruzDoSul         |  90 ++++++++++
 dvbv5_isdb-t/br-rs-SantaMaria             |  61 +++++++
 dvbv5_isdb-t/br-rs-SantaRosa              |  32 ++++
 dvbv5_isdb-t/br-rs-SantanaDoLivramento    |  32 ++++
 dvbv5_isdb-t/br-rs-SantoAngelo            |  61 +++++++
 dvbv5_isdb-t/br-rs-SantoAntonioDaPatrulha | 264 ++++++++++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-SaoBorja               |  32 ++++
 dvbv5_isdb-t/br-rs-SaoGabriel             |  32 ++++
 dvbv5_isdb-t/br-rs-SaoJoseDoNorte         |  61 +++++++
 dvbv5_isdb-t/br-rs-SaoSepe                |  61 +++++++
 dvbv5_isdb-t/br-rs-Sapiranga              |  32 ++++
 dvbv5_isdb-t/br-rs-Sertao                 |  61 +++++++
 dvbv5_isdb-t/br-rs-Taquara                |  32 ++++
 dvbv5_isdb-t/br-rs-TerraDeAreia           |  90 ++++++++++
 dvbv5_isdb-t/br-rs-Torres                 |  32 ++++
 dvbv5_isdb-t/br-rs-Tramandai              |  90 ++++++++++
 dvbv5_isdb-t/br-rs-TresCachoeiras         |  32 ++++
 dvbv5_isdb-t/br-rs-TresCoroas             |  32 ++++
 dvbv5_isdb-t/br-rs-TresDeMaio             |  32 ++++
 dvbv5_isdb-t/br-rs-Triunfo                | 235 ++++++++++++++++++++++++++
 dvbv5_isdb-t/br-rs-Tucunduva              |  32 ++++
 dvbv5_isdb-t/br-rs-Uruguaiana             |  61 +++++++
 dvbv5_isdb-t/br-rs-Vacaria                |  61 +++++++
 dvbv5_isdb-t/br-rs-VenancioAires          |  32 ++++
 dvbv5_isdb-t/br-rs-VilaNovaDoSul          |  32 ++++
 dvbv5_isdb-t/br-rs-Xangrila               |  90 ++++++++++
 69 files changed, 4731 insertions(+)
 create mode 100644 dvbv5_isdb-t/br-rs-Alegrete
 create mode 100644 dvbv5_isdb-t/br-rs-ArroioDoSal
 create mode 100644 dvbv5_isdb-t/br-rs-Bage
 create mode 100644 dvbv5_isdb-t/br-rs-BentoGoncalves
 create mode 100644 dvbv5_isdb-t/br-rs-CachoeiraDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-Camaqua
 create mode 100644 dvbv5_isdb-t/br-rs-CampoBom
 create mode 100644 dvbv5_isdb-t/br-rs-Candelaria
 create mode 100644 dvbv5_isdb-t/br-rs-Canela
 create mode 100644 dvbv5_isdb-t/br-rs-Cangucu
 create mode 100644 dvbv5_isdb-t/br-rs-CapaoDaCanoa
 create mode 100644 dvbv5_isdb-t/br-rs-CapaoDoLeao
 create mode 100644 dvbv5_isdb-t/br-rs-Carazinho
 create mode 100644 dvbv5_isdb-t/br-rs-CarlosBarbosa
 create mode 100644 dvbv5_isdb-t/br-rs-CaxiasDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-Cidreira
 create mode 100644 dvbv5_isdb-t/br-rs-CruzAlta
 create mode 100644 dvbv5_isdb-t/br-rs-DomPedroDeAlcantara
 create mode 100644 dvbv5_isdb-t/br-rs-Erechim
 create mode 100644 dvbv5_isdb-t/br-rs-Estrela
 create mode 100644 dvbv5_isdb-t/br-rs-Farroupilha
 create mode 100644 dvbv5_isdb-t/br-rs-Feliz
 create mode 100644 dvbv5_isdb-t/br-rs-FloresDaCunha
 create mode 100644 dvbv5_isdb-t/br-rs-Gramado
 create mode 100644 dvbv5_isdb-t/br-rs-Ijui
 create mode 100644 dvbv5_isdb-t/br-rs-Lajeado
 create mode 100644 dvbv5_isdb-t/br-rs-MonteAlegreDosCampos
 create mode 100644 dvbv5_isdb-t/br-rs-Montenegro
 create mode 100644 dvbv5_isdb-t/br-rs-MorroRedondo
 create mode 100644 dvbv5_isdb-t/br-rs-NovaPetropolis
 create mode 100644 dvbv5_isdb-t/br-rs-NovaSantaRita
 create mode 100644 dvbv5_isdb-t/br-rs-NovoHamburgo
 create mode 100644 dvbv5_isdb-t/br-rs-Osorio
 create mode 100644 dvbv5_isdb-t/br-rs-PalmaresDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-ParaisoDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-PassoFundo
 create mode 100644 dvbv5_isdb-t/br-rs-Pelotas
 create mode 100644 dvbv5_isdb-t/br-rs-PicadaCafe
 create mode 100644 dvbv5_isdb-t/br-rs-PortoAlegre
 create mode 100644 dvbv5_isdb-t/br-rs-RioGrande
 create mode 100644 dvbv5_isdb-t/br-rs-RioGrandeCassino
 create mode 100644 dvbv5_isdb-t/br-rs-SalvadorDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-Sananduva
 create mode 100644 dvbv5_isdb-t/br-rs-SantaCruzDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-SantaMaria
 create mode 100644 dvbv5_isdb-t/br-rs-SantaRosa
 create mode 100644 dvbv5_isdb-t/br-rs-SantanaDoLivramento
 create mode 100644 dvbv5_isdb-t/br-rs-SantoAngelo
 create mode 100644 dvbv5_isdb-t/br-rs-SantoAntonioDaPatrulha
 create mode 100644 dvbv5_isdb-t/br-rs-SaoBorja
 create mode 100644 dvbv5_isdb-t/br-rs-SaoGabriel
 create mode 100644 dvbv5_isdb-t/br-rs-SaoJoseDoNorte
 create mode 100644 dvbv5_isdb-t/br-rs-SaoSepe
 create mode 100644 dvbv5_isdb-t/br-rs-Sapiranga
 create mode 100644 dvbv5_isdb-t/br-rs-Sertao
 create mode 100644 dvbv5_isdb-t/br-rs-Taquara
 create mode 100644 dvbv5_isdb-t/br-rs-TerraDeAreia
 create mode 100644 dvbv5_isdb-t/br-rs-Torres
 create mode 100644 dvbv5_isdb-t/br-rs-Tramandai
 create mode 100644 dvbv5_isdb-t/br-rs-TresCachoeiras
 create mode 100644 dvbv5_isdb-t/br-rs-TresCoroas
 create mode 100644 dvbv5_isdb-t/br-rs-TresDeMaio
 create mode 100644 dvbv5_isdb-t/br-rs-Triunfo
 create mode 100644 dvbv5_isdb-t/br-rs-Tucunduva
 create mode 100644 dvbv5_isdb-t/br-rs-Uruguaiana
 create mode 100644 dvbv5_isdb-t/br-rs-Vacaria
 create mode 100644 dvbv5_isdb-t/br-rs-VenancioAires
 create mode 100644 dvbv5_isdb-t/br-rs-VilaNovaDoSul
 create mode 100644 dvbv5_isdb-t/br-rs-Xangrila

diff --git a/dvbv5_isdb-t/br-rs-Alegrete b/dvbv5_isdb-t/br-rs-Alegrete
new file mode 100644
index 000000000000..44a22f10a774
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Alegrete
@@ -0,0 +1,61 @@
+# Channel table for Alegrete - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=898
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
diff --git a/dvbv5_isdb-t/br-rs-ArroioDoSal b/dvbv5_isdb-t/br-rs-ArroioDoSal
new file mode 100644
index 000000000000..96b3ad229d37
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-ArroioDoSal
@@ -0,0 +1,90 @@
+# Channel table for Arroio do Sal - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1465
+
+# Physical channel 24
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Bage b/dvbv5_isdb-t/br-rs-Bage
new file mode 100644
index 000000000000..34ae98c9d5e4
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Bage
@@ -0,0 +1,61 @@
+# Channel table for Bagé - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=72
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
diff --git a/dvbv5_isdb-t/br-rs-BentoGoncalves b/dvbv5_isdb-t/br-rs-BentoGoncalves
new file mode 100644
index 000000000000..21b18f8c323d
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-BentoGoncalves
@@ -0,0 +1,32 @@
+# Channel table for Bento Gonçalves - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1632
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
diff --git a/dvbv5_isdb-t/br-rs-CachoeiraDoSul b/dvbv5_isdb-t/br-rs-CachoeiraDoSul
new file mode 100644
index 000000000000..034c48613eef
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CachoeiraDoSul
@@ -0,0 +1,61 @@
+# Channel table for Cachoeira do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=762
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
+# Physical channel 42
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Camaqua b/dvbv5_isdb-t/br-rs-Camaqua
new file mode 100644
index 000000000000..8af9e38fb2dd
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Camaqua
@@ -0,0 +1,32 @@
+# Channel table for Camaquã - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2126
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
diff --git a/dvbv5_isdb-t/br-rs-CampoBom b/dvbv5_isdb-t/br-rs-CampoBom
new file mode 100644
index 000000000000..fa696410c2f5
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CampoBom
@@ -0,0 +1,206 @@
+# Channel table for Campo Bom - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2091
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
diff --git a/dvbv5_isdb-t/br-rs-Candelaria b/dvbv5_isdb-t/br-rs-Candelaria
new file mode 100644
index 000000000000..be32765676ec
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Candelaria
@@ -0,0 +1,61 @@
+# Channel table for Candelária - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=755
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
+# Physical channel 38
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-Canela b/dvbv5_isdb-t/br-rs-Canela
new file mode 100644
index 000000000000..03922954b1de
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Canela
@@ -0,0 +1,32 @@
+# Channel table for Canela - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1634
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
diff --git a/dvbv5_isdb-t/br-rs-Cangucu b/dvbv5_isdb-t/br-rs-Cangucu
new file mode 100644
index 000000000000..a740b8309c78
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Cangucu
@@ -0,0 +1,32 @@
+# Channel table for Canguçu - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2119
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
diff --git a/dvbv5_isdb-t/br-rs-CapaoDaCanoa b/dvbv5_isdb-t/br-rs-CapaoDaCanoa
new file mode 100644
index 000000000000..655361ee1179
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CapaoDaCanoa
@@ -0,0 +1,32 @@
+# Channel table for Capão da Canoa - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1466
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
diff --git a/dvbv5_isdb-t/br-rs-CapaoDoLeao b/dvbv5_isdb-t/br-rs-CapaoDoLeao
new file mode 100644
index 000000000000..8edf6c47af3c
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CapaoDoLeao
@@ -0,0 +1,32 @@
+# Channel table for Capão do Leão - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2130
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
diff --git a/dvbv5_isdb-t/br-rs-Carazinho b/dvbv5_isdb-t/br-rs-Carazinho
new file mode 100644
index 000000000000..2b49c8a81f7a
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Carazinho
@@ -0,0 +1,32 @@
+# Channel table for Carazinho - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=62
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
diff --git a/dvbv5_isdb-t/br-rs-CarlosBarbosa b/dvbv5_isdb-t/br-rs-CarlosBarbosa
new file mode 100644
index 000000000000..eea4ea3f71cf
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CarlosBarbosa
@@ -0,0 +1,32 @@
+# Channel table for Carlos Barbosa - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1631
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
diff --git a/dvbv5_isdb-t/br-rs-CaxiasDoSul b/dvbv5_isdb-t/br-rs-CaxiasDoSul
new file mode 100644
index 000000000000..e156302455a3
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CaxiasDoSul
@@ -0,0 +1,61 @@
+# Channel table for Caxias do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=227
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
+# Physical channel 38
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-Cidreira b/dvbv5_isdb-t/br-rs-Cidreira
new file mode 100644
index 000000000000..9c354a948545
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Cidreira
@@ -0,0 +1,61 @@
+# Channel table for Cidreira - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2085
+
+# Physical channel 23
+[RBS TV]
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
+# Physical channel 32
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-CruzAlta b/dvbv5_isdb-t/br-rs-CruzAlta
new file mode 100644
index 000000000000..e28b630351cc
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-CruzAlta
@@ -0,0 +1,32 @@
+# Channel table for Cruz Alta - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=75
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
diff --git a/dvbv5_isdb-t/br-rs-DomPedroDeAlcantara b/dvbv5_isdb-t/br-rs-DomPedroDeAlcantara
new file mode 100644
index 000000000000..ddb0f3ad79ad
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-DomPedroDeAlcantara
@@ -0,0 +1,32 @@
+# Channel table for Dom Pedro de Alcântara - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2095
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
diff --git a/dvbv5_isdb-t/br-rs-Erechim b/dvbv5_isdb-t/br-rs-Erechim
new file mode 100644
index 000000000000..96839c4df582
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Erechim
@@ -0,0 +1,61 @@
+# Channel table for Erechim - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=74
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
diff --git a/dvbv5_isdb-t/br-rs-Estrela b/dvbv5_isdb-t/br-rs-Estrela
new file mode 100644
index 000000000000..1f1dbefeee21
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Estrela
@@ -0,0 +1,32 @@
+# Channel table for Estrela - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1968
+
+# Physical channel 25
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Farroupilha b/dvbv5_isdb-t/br-rs-Farroupilha
new file mode 100644
index 000000000000..42bd4cb84bc1
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Farroupilha
@@ -0,0 +1,61 @@
+# Channel table for Farroupilha - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1971
+
+# Physical channel 23
+[RBS TV]
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
+# Physical channel 38
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-Feliz b/dvbv5_isdb-t/br-rs-Feliz
new file mode 100644
index 000000000000..ec8b896ba115
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Feliz
@@ -0,0 +1,32 @@
+# Channel table for Feliz - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1979
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
diff --git a/dvbv5_isdb-t/br-rs-FloresDaCunha b/dvbv5_isdb-t/br-rs-FloresDaCunha
new file mode 100644
index 000000000000..4acf2d24d7cc
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-FloresDaCunha
@@ -0,0 +1,32 @@
+# Channel table for Flores da Cunha - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1630
+
+# Physical channel 42
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Gramado b/dvbv5_isdb-t/br-rs-Gramado
new file mode 100644
index 000000000000..df5941795690
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Gramado
@@ -0,0 +1,32 @@
+# Channel table for Gramado - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=138
+
+# Physical channel 23
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Ijui b/dvbv5_isdb-t/br-rs-Ijui
new file mode 100644
index 000000000000..d2208571d552
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Ijui
@@ -0,0 +1,32 @@
+# Channel table for Ijuí - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=897
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
diff --git a/dvbv5_isdb-t/br-rs-Lajeado b/dvbv5_isdb-t/br-rs-Lajeado
new file mode 100644
index 000000000000..6e1bb166cf75
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Lajeado
@@ -0,0 +1,32 @@
+# Channel table for Lajeado - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=764
+
+# Physical channel 25
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-MonteAlegreDosCampos b/dvbv5_isdb-t/br-rs-MonteAlegreDosCampos
new file mode 100644
index 000000000000..b4db8872e042
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-MonteAlegreDosCampos
@@ -0,0 +1,61 @@
+# Channel table for Monte Alegre dos Campos - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2041
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
diff --git a/dvbv5_isdb-t/br-rs-Montenegro b/dvbv5_isdb-t/br-rs-Montenegro
new file mode 100644
index 000000000000..c41d58b72be1
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Montenegro
@@ -0,0 +1,235 @@
+# Channel table for Montenegro - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2038
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
diff --git a/dvbv5_isdb-t/br-rs-MorroRedondo b/dvbv5_isdb-t/br-rs-MorroRedondo
new file mode 100644
index 000000000000..d25c904ca48b
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-MorroRedondo
@@ -0,0 +1,32 @@
+# Channel table for Morro Redondo - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2132
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
diff --git a/dvbv5_isdb-t/br-rs-NovaPetropolis b/dvbv5_isdb-t/br-rs-NovaPetropolis
new file mode 100644
index 000000000000..58cf85513d59
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-NovaPetropolis
@@ -0,0 +1,32 @@
+# Channel table for Nova Petrópolis - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2157
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
diff --git a/dvbv5_isdb-t/br-rs-NovaSantaRita b/dvbv5_isdb-t/br-rs-NovaSantaRita
new file mode 100644
index 000000000000..4840e6de1cb7
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-NovaSantaRita
@@ -0,0 +1,206 @@
+# Channel table for Nova Santa Rita - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3072
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 30
+[TVE RS]
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
+# Physical channel 32
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-NovoHamburgo b/dvbv5_isdb-t/br-rs-NovoHamburgo
new file mode 100644
index 000000000000..9db263a47be5
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-NovoHamburgo
@@ -0,0 +1,264 @@
+# Channel table for Novo Hamburgo - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2149
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 30
+[TVE RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
diff --git a/dvbv5_isdb-t/br-rs-Osorio b/dvbv5_isdb-t/br-rs-Osorio
new file mode 100644
index 000000000000..61f47fefe92b
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Osorio
@@ -0,0 +1,148 @@
+# Channel table for Osório - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=761
+
+# Physical channel 21
+[Record RS]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 32
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-PalmaresDoSul b/dvbv5_isdb-t/br-rs-PalmaresDoSul
new file mode 100644
index 000000000000..bb17fdebba11
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-PalmaresDoSul
@@ -0,0 +1,32 @@
+# Channel table for Palmares do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2148
+
+# Physical channel 23
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-ParaisoDoSul b/dvbv5_isdb-t/br-rs-ParaisoDoSul
new file mode 100644
index 000000000000..3face297894e
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-ParaisoDoSul
@@ -0,0 +1,32 @@
+# Channel table for Paraíso do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=337
+
+# Physical channel 42
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-PassoFundo b/dvbv5_isdb-t/br-rs-PassoFundo
new file mode 100644
index 000000000000..50965ba07d98
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-PassoFundo
@@ -0,0 +1,61 @@
+# Channel table for Passo Fundo - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=61
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
diff --git a/dvbv5_isdb-t/br-rs-Pelotas b/dvbv5_isdb-t/br-rs-Pelotas
new file mode 100644
index 000000000000..8ac6f644dd67
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Pelotas
@@ -0,0 +1,61 @@
+# Channel table for Pelotas - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=70
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
diff --git a/dvbv5_isdb-t/br-rs-PicadaCafe b/dvbv5_isdb-t/br-rs-PicadaCafe
new file mode 100644
index 000000000000..f4e4292aaccd
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-PicadaCafe
@@ -0,0 +1,32 @@
+# Channel table for Picada Café - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2171
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
diff --git a/dvbv5_isdb-t/br-rs-PortoAlegre b/dvbv5_isdb-t/br-rs-PortoAlegre
new file mode 100644
index 000000000000..a9543bde2c2d
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-PortoAlegre
@@ -0,0 +1,264 @@
+# Channel table for Porto Alegre - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=29
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 30
+[TVE RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
+# Physical channel 65
+[TV Brasil]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 779142857
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
diff --git a/dvbv5_isdb-t/br-rs-RioGrande b/dvbv5_isdb-t/br-rs-RioGrande
new file mode 100644
index 000000000000..b07dd27751a6
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-RioGrande
@@ -0,0 +1,61 @@
+# Channel table for Rio Grande - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=73
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
diff --git a/dvbv5_isdb-t/br-rs-RioGrandeCassino b/dvbv5_isdb-t/br-rs-RioGrandeCassino
new file mode 100644
index 000000000000..3927ed4b4b97
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-RioGrandeCassino
@@ -0,0 +1,32 @@
+# Channel table for Rio Grande (Cassino) - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1896
+
+# Physical channel 23
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-SalvadorDoSul b/dvbv5_isdb-t/br-rs-SalvadorDoSul
new file mode 100644
index 000000000000..df7af786d473
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SalvadorDoSul
@@ -0,0 +1,148 @@
+# Channel table for Salvador do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1912
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 32
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-Sananduva b/dvbv5_isdb-t/br-rs-Sananduva
new file mode 100644
index 000000000000..864fc089f6f7
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Sananduva
@@ -0,0 +1,32 @@
+# Channel table for Sananduva - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1913
+
+# Physical channel 18
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-SantaCruzDoSul b/dvbv5_isdb-t/br-rs-SantaCruzDoSul
new file mode 100644
index 000000000000..9ee36514b8ab
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantaCruzDoSul
@@ -0,0 +1,90 @@
+# Channel table for Santa Cruz do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=76
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
+# Physical channel 38
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-SantaMaria b/dvbv5_isdb-t/br-rs-SantaMaria
new file mode 100644
index 000000000000..6597bab2702f
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantaMaria
@@ -0,0 +1,61 @@
+# Channel table for Santa Maria - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=71
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
diff --git a/dvbv5_isdb-t/br-rs-SantaRosa b/dvbv5_isdb-t/br-rs-SantaRosa
new file mode 100644
index 000000000000..97708ec9285e
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantaRosa
@@ -0,0 +1,32 @@
+# Channel table for Santa Rosa - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=901
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
diff --git a/dvbv5_isdb-t/br-rs-SantanaDoLivramento b/dvbv5_isdb-t/br-rs-SantanaDoLivramento
new file mode 100644
index 000000000000..c1faf15c386d
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantanaDoLivramento
@@ -0,0 +1,32 @@
+# Channel table for Santana do Livramento - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=147
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
diff --git a/dvbv5_isdb-t/br-rs-SantoAngelo b/dvbv5_isdb-t/br-rs-SantoAngelo
new file mode 100644
index 000000000000..92e1d928fc22
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantoAngelo
@@ -0,0 +1,61 @@
+# Channel table for Santo Ângelo - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=462
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
+# Physical channel 23
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-SantoAntonioDaPatrulha b/dvbv5_isdb-t/br-rs-SantoAntonioDaPatrulha
new file mode 100644
index 000000000000..08cbfa4d2fca
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SantoAntonioDaPatrulha
@@ -0,0 +1,264 @@
+# Channel table for Santo Antonio da Patrulha - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1895
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 23
+[RBS TV]
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
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 30
+[TVE RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
diff --git a/dvbv5_isdb-t/br-rs-SaoBorja b/dvbv5_isdb-t/br-rs-SaoBorja
new file mode 100644
index 000000000000..b917771137d2
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SaoBorja
@@ -0,0 +1,32 @@
+# Channel table for São Borja - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=686
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
diff --git a/dvbv5_isdb-t/br-rs-SaoGabriel b/dvbv5_isdb-t/br-rs-SaoGabriel
new file mode 100644
index 000000000000..9339b189a88b
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SaoGabriel
@@ -0,0 +1,32 @@
+# Channel table for São Gabriel - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=640
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
diff --git a/dvbv5_isdb-t/br-rs-SaoJoseDoNorte b/dvbv5_isdb-t/br-rs-SaoJoseDoNorte
new file mode 100644
index 000000000000..7119993f9cdd
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SaoJoseDoNorte
@@ -0,0 +1,61 @@
+# Channel table for São José do Norte - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1951
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
diff --git a/dvbv5_isdb-t/br-rs-SaoSepe b/dvbv5_isdb-t/br-rs-SaoSepe
new file mode 100644
index 000000000000..63da3085e822
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-SaoSepe
@@ -0,0 +1,61 @@
+# Channel table for São Sepé - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1947
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
diff --git a/dvbv5_isdb-t/br-rs-Sapiranga b/dvbv5_isdb-t/br-rs-Sapiranga
new file mode 100644
index 000000000000..fe4a478c2229
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Sapiranga
@@ -0,0 +1,32 @@
+# Channel table for Sapiranga - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1921
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
diff --git a/dvbv5_isdb-t/br-rs-Sertao b/dvbv5_isdb-t/br-rs-Sertao
new file mode 100644
index 000000000000..7c281f2f6d17
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Sertao
@@ -0,0 +1,61 @@
+# Channel table for Sertão - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1924
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
diff --git a/dvbv5_isdb-t/br-rs-Taquara b/dvbv5_isdb-t/br-rs-Taquara
new file mode 100644
index 000000000000..4df5c7310424
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Taquara
@@ -0,0 +1,32 @@
+# Channel table for Taquara - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1127
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
diff --git a/dvbv5_isdb-t/br-rs-TerraDeAreia b/dvbv5_isdb-t/br-rs-TerraDeAreia
new file mode 100644
index 000000000000..fe3f04f28917
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-TerraDeAreia
@@ -0,0 +1,90 @@
+# Channel table for Terra de Areia - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1887
+
+# Physical channel 24
+[RBS TV]
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
diff --git a/dvbv5_isdb-t/br-rs-Torres b/dvbv5_isdb-t/br-rs-Torres
new file mode 100644
index 000000000000..4b446d50c0f6
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Torres
@@ -0,0 +1,32 @@
+# Channel table for Torres - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=563
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
diff --git a/dvbv5_isdb-t/br-rs-Tramandai b/dvbv5_isdb-t/br-rs-Tramandai
new file mode 100644
index 000000000000..70942174fab8
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Tramandai
@@ -0,0 +1,90 @@
+# Channel table for Tramandaí - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1467
+
+# Physical channel 23
+[RBS TV]
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
+# Physical channel 32
+[Band RS]
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
diff --git a/dvbv5_isdb-t/br-rs-TresCachoeiras b/dvbv5_isdb-t/br-rs-TresCachoeiras
new file mode 100644
index 000000000000..11a67dd5cc3c
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-TresCachoeiras
@@ -0,0 +1,32 @@
+# Channel table for Três Cachoeiras - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1892
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
diff --git a/dvbv5_isdb-t/br-rs-TresCoroas b/dvbv5_isdb-t/br-rs-TresCoroas
new file mode 100644
index 000000000000..e6b1629088d6
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-TresCoroas
@@ -0,0 +1,32 @@
+# Channel table for Três Coroas - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1893
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
diff --git a/dvbv5_isdb-t/br-rs-TresDeMaio b/dvbv5_isdb-t/br-rs-TresDeMaio
new file mode 100644
index 000000000000..febb6aa3fc51
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-TresDeMaio
@@ -0,0 +1,32 @@
+# Channel table for Três de Maio - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1882
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
diff --git a/dvbv5_isdb-t/br-rs-Triunfo b/dvbv5_isdb-t/br-rs-Triunfo
new file mode 100644
index 000000000000..0ca9fd456c7f
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Triunfo
@@ -0,0 +1,235 @@
+# Channel table for Triunfo - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1866
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
+# Physical channel 21
+[Record RS]
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
+# Physical channel 26
+[TV Pampa]
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
+# Physical channel 28
+[SBT RS]
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
+# Physical channel 30
+[TVE RS]
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
+# Physical channel 32
+[Band RS]
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
+# Physical channel 61
+[TV Câmara, ALTV, TV Senado, TV Câmara Municipal]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 755142857
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
diff --git a/dvbv5_isdb-t/br-rs-Tucunduva b/dvbv5_isdb-t/br-rs-Tucunduva
new file mode 100644
index 000000000000..0e43fa16a836
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Tucunduva
@@ -0,0 +1,32 @@
+# Channel table for Tucunduva - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=558
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
diff --git a/dvbv5_isdb-t/br-rs-Uruguaiana b/dvbv5_isdb-t/br-rs-Uruguaiana
new file mode 100644
index 000000000000..6e6422ab44a3
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Uruguaiana
@@ -0,0 +1,61 @@
+# Channel table for Uruguaiana - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=902
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
diff --git a/dvbv5_isdb-t/br-rs-Vacaria b/dvbv5_isdb-t/br-rs-Vacaria
new file mode 100644
index 000000000000..7cc4ca6f2888
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Vacaria
@@ -0,0 +1,61 @@
+# Channel table for Vacaria - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=763
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
diff --git a/dvbv5_isdb-t/br-rs-VenancioAires b/dvbv5_isdb-t/br-rs-VenancioAires
new file mode 100644
index 000000000000..a96543dadb75
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-VenancioAires
@@ -0,0 +1,32 @@
+# Channel table for Venâncio Aires - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1874
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
diff --git a/dvbv5_isdb-t/br-rs-VilaNovaDoSul b/dvbv5_isdb-t/br-rs-VilaNovaDoSul
new file mode 100644
index 000000000000..f50918f09e3e
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-VilaNovaDoSul
@@ -0,0 +1,32 @@
+# Channel table for Vila Nova do Sul - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1880
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
diff --git a/dvbv5_isdb-t/br-rs-Xangrila b/dvbv5_isdb-t/br-rs-Xangrila
new file mode 100644
index 000000000000..fc6e77b39c68
--- /dev/null
+++ b/dvbv5_isdb-t/br-rs-Xangrila
@@ -0,0 +1,90 @@
+# Channel table for Xangri-Lá - RS - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2134
+
+# Physical channel 32
+[Band RS]
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
-- 
1.9.3

