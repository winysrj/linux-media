Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaE0Qu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 12:50:57 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/12] Add Brazil's Bahia state tables
Date: Tue, 27 May 2014 13:50:23 -0300
Message-Id: <1401209432-7327-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
References: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 dvbv5_isdb-t/br-ba-Alagoinhas             |  61 ++++++++
 dvbv5_isdb-t/br-ba-Alcobaca               |  32 ++++
 dvbv5_isdb-t/br-ba-Amargosa               |  32 ++++
 dvbv5_isdb-t/br-ba-AmeliaRodrigues        | 206 ++++++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-Anguera                |  61 ++++++++
 dvbv5_isdb-t/br-ba-AntonioCardoso         |  61 ++++++++
 dvbv5_isdb-t/br-ba-Aracatu                |  32 ++++
 dvbv5_isdb-t/br-ba-Barra                  |  32 ++++
 dvbv5_isdb-t/br-ba-BarraDoChoca           |  61 ++++++++
 dvbv5_isdb-t/br-ba-Barreiras              |  61 ++++++++
 dvbv5_isdb-t/br-ba-BeloCampo              |  61 ++++++++
 dvbv5_isdb-t/br-ba-Biritinga              |  32 ++++
 dvbv5_isdb-t/br-ba-BomJesusDaLapa         |  32 ++++
 dvbv5_isdb-t/br-ba-Brumado                |  32 ++++
 dvbv5_isdb-t/br-ba-Caetite                |  32 ++++
 dvbv5_isdb-t/br-ba-Camacari               | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-CampoFormoso           |  32 ++++
 dvbv5_isdb-t/br-ba-Candeal                |  61 ++++++++
 dvbv5_isdb-t/br-ba-Candeias               | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-CandidoSales           |  32 ++++
 dvbv5_isdb-t/br-ba-Caraibas               |  32 ++++
 dvbv5_isdb-t/br-ba-ConceicaoDaFeira       |  32 ++++
 dvbv5_isdb-t/br-ba-ConceicaoDoJacuipe     |  32 ++++
 dvbv5_isdb-t/br-ba-CoracaoDeMaria         |  61 ++++++++
 dvbv5_isdb-t/br-ba-CruzDasAlmas           | 235 ++++++++++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-DiasDAvila             | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-EntreRios              |  32 ++++
 dvbv5_isdb-t/br-ba-Eunapolis              |  32 ++++
 dvbv5_isdb-t/br-ba-FeiraDeSantana         |  61 ++++++++
 dvbv5_isdb-t/br-ba-Guanambi               |  32 ++++
 dvbv5_isdb-t/br-ba-Ichu                   |  32 ++++
 dvbv5_isdb-t/br-ba-Ilheus                 |  32 ++++
 dvbv5_isdb-t/br-ba-Inhambupe              |  32 ++++
 dvbv5_isdb-t/br-ba-Ipecaeta               |  61 ++++++++
 dvbv5_isdb-t/br-ba-Irara                  |  61 ++++++++
 dvbv5_isdb-t/br-ba-Irece                  |  61 ++++++++
 dvbv5_isdb-t/br-ba-Itabuna                |  32 ++++
 dvbv5_isdb-t/br-ba-Itamaraju              |  61 ++++++++
 dvbv5_isdb-t/br-ba-Itambe                 |  32 ++++
 dvbv5_isdb-t/br-ba-Itaparica              | 148 +++++++++++++++++++
 dvbv5_isdb-t/br-ba-Itapetinga             |  32 ++++
 dvbv5_isdb-t/br-ba-Jacobina               |  32 ++++
 dvbv5_isdb-t/br-ba-Jaguaquara             |  32 ++++
 dvbv5_isdb-t/br-ba-Jaguaripe              | 148 +++++++++++++++++++
 dvbv5_isdb-t/br-ba-Jequie                 |  32 ++++
 dvbv5_isdb-t/br-ba-Juazeiro               |  90 ++++++++++++
 dvbv5_isdb-t/br-ba-LauroDeFreitas         | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-LuisEduardoMagalhaes   |  32 ++++
 dvbv5_isdb-t/br-ba-MadreDeDeus            | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-Maragogipe             | 148 +++++++++++++++++++
 dvbv5_isdb-t/br-ba-MataDeSaoJoao          | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-Nazare                 | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-PauloAfonso            |  32 ++++
 dvbv5_isdb-t/br-ba-Piripa                 |  32 ++++
 dvbv5_isdb-t/br-ba-Planalto               |  32 ++++
 dvbv5_isdb-t/br-ba-Pocoes                 |  32 ++++
 dvbv5_isdb-t/br-ba-Pojuca                 | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-PortoSeguro            |  32 ++++
 dvbv5_isdb-t/br-ba-PresidenteJanioQuadros |  32 ++++
 dvbv5_isdb-t/br-ba-RafaelJambeiro         |  32 ++++
 dvbv5_isdb-t/br-ba-SalinasDaMargarida     | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-Salvador               | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-SantaBarbara           |  61 ++++++++
 dvbv5_isdb-t/br-ba-SantaCruzCabralia      |  32 ++++
 dvbv5_isdb-t/br-ba-SantaMariaDaVitoria    |  32 ++++
 dvbv5_isdb-t/br-ba-Santanopolis           |  61 ++++++++
 dvbv5_isdb-t/br-ba-SantoAmaro             | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-SantoAntonioDeJesus    | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-SantoEstevao           |  61 ++++++++
 dvbv5_isdb-t/br-ba-SaoFranciscoDoConde    | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-SaoGoncaloDosCampos    |  61 ++++++++
 dvbv5_isdb-t/br-ba-SaoSebastiaoDoPasse    | 206 ++++++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-SenhorDoBonfim         |  32 ++++
 dvbv5_isdb-t/br-ba-SerraPreta             |  61 ++++++++
 dvbv5_isdb-t/br-ba-Serrinha               |  32 ++++
 dvbv5_isdb-t/br-ba-SimoesFilho            | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-Tanquinho              |  61 ++++++++
 dvbv5_isdb-t/br-ba-TeixeiraDeFreitas      |  61 ++++++++
 dvbv5_isdb-t/br-ba-Teofilandia            |  32 ++++
 dvbv5_isdb-t/br-ba-Tremedal               |  32 ++++
 dvbv5_isdb-t/br-ba-VeraCruz               | 177 ++++++++++++++++++++++
 dvbv5_isdb-t/br-ba-VitoriaDaConquista     |  61 ++++++++
 dvbv5_isdb-t/br-ba-Xiquexique             |  32 ++++
 83 files changed, 6397 insertions(+)
 create mode 100644 dvbv5_isdb-t/br-ba-Alagoinhas
 create mode 100644 dvbv5_isdb-t/br-ba-Alcobaca
 create mode 100644 dvbv5_isdb-t/br-ba-Amargosa
 create mode 100644 dvbv5_isdb-t/br-ba-AmeliaRodrigues
 create mode 100644 dvbv5_isdb-t/br-ba-Anguera
 create mode 100644 dvbv5_isdb-t/br-ba-AntonioCardoso
 create mode 100644 dvbv5_isdb-t/br-ba-Aracatu
 create mode 100644 dvbv5_isdb-t/br-ba-Barra
 create mode 100644 dvbv5_isdb-t/br-ba-BarraDoChoca
 create mode 100644 dvbv5_isdb-t/br-ba-Barreiras
 create mode 100644 dvbv5_isdb-t/br-ba-BeloCampo
 create mode 100644 dvbv5_isdb-t/br-ba-Biritinga
 create mode 100644 dvbv5_isdb-t/br-ba-BomJesusDaLapa
 create mode 100644 dvbv5_isdb-t/br-ba-Brumado
 create mode 100644 dvbv5_isdb-t/br-ba-Caetite
 create mode 100644 dvbv5_isdb-t/br-ba-Camacari
 create mode 100644 dvbv5_isdb-t/br-ba-CampoFormoso
 create mode 100644 dvbv5_isdb-t/br-ba-Candeal
 create mode 100644 dvbv5_isdb-t/br-ba-Candeias
 create mode 100644 dvbv5_isdb-t/br-ba-CandidoSales
 create mode 100644 dvbv5_isdb-t/br-ba-Caraibas
 create mode 100644 dvbv5_isdb-t/br-ba-ConceicaoDaFeira
 create mode 100644 dvbv5_isdb-t/br-ba-ConceicaoDoJacuipe
 create mode 100644 dvbv5_isdb-t/br-ba-CoracaoDeMaria
 create mode 100644 dvbv5_isdb-t/br-ba-CruzDasAlmas
 create mode 100644 dvbv5_isdb-t/br-ba-DiasDAvila
 create mode 100644 dvbv5_isdb-t/br-ba-EntreRios
 create mode 100644 dvbv5_isdb-t/br-ba-Eunapolis
 create mode 100644 dvbv5_isdb-t/br-ba-FeiraDeSantana
 create mode 100644 dvbv5_isdb-t/br-ba-Guanambi
 create mode 100644 dvbv5_isdb-t/br-ba-Ichu
 create mode 100644 dvbv5_isdb-t/br-ba-Ilheus
 create mode 100644 dvbv5_isdb-t/br-ba-Inhambupe
 create mode 100644 dvbv5_isdb-t/br-ba-Ipecaeta
 create mode 100644 dvbv5_isdb-t/br-ba-Irara
 create mode 100644 dvbv5_isdb-t/br-ba-Irece
 create mode 100644 dvbv5_isdb-t/br-ba-Itabuna
 create mode 100644 dvbv5_isdb-t/br-ba-Itamaraju
 create mode 100644 dvbv5_isdb-t/br-ba-Itambe
 create mode 100644 dvbv5_isdb-t/br-ba-Itaparica
 create mode 100644 dvbv5_isdb-t/br-ba-Itapetinga
 create mode 100644 dvbv5_isdb-t/br-ba-Jacobina
 create mode 100644 dvbv5_isdb-t/br-ba-Jaguaquara
 create mode 100644 dvbv5_isdb-t/br-ba-Jaguaripe
 create mode 100644 dvbv5_isdb-t/br-ba-Jequie
 create mode 100644 dvbv5_isdb-t/br-ba-Juazeiro
 create mode 100644 dvbv5_isdb-t/br-ba-LauroDeFreitas
 create mode 100644 dvbv5_isdb-t/br-ba-LuisEduardoMagalhaes
 create mode 100644 dvbv5_isdb-t/br-ba-MadreDeDeus
 create mode 100644 dvbv5_isdb-t/br-ba-Maragogipe
 create mode 100644 dvbv5_isdb-t/br-ba-MataDeSaoJoao
 create mode 100644 dvbv5_isdb-t/br-ba-Nazare
 create mode 100644 dvbv5_isdb-t/br-ba-PauloAfonso
 create mode 100644 dvbv5_isdb-t/br-ba-Piripa
 create mode 100644 dvbv5_isdb-t/br-ba-Planalto
 create mode 100644 dvbv5_isdb-t/br-ba-Pocoes
 create mode 100644 dvbv5_isdb-t/br-ba-Pojuca
 create mode 100644 dvbv5_isdb-t/br-ba-PortoSeguro
 create mode 100644 dvbv5_isdb-t/br-ba-PresidenteJanioQuadros
 create mode 100644 dvbv5_isdb-t/br-ba-RafaelJambeiro
 create mode 100644 dvbv5_isdb-t/br-ba-SalinasDaMargarida
 create mode 100644 dvbv5_isdb-t/br-ba-Salvador
 create mode 100644 dvbv5_isdb-t/br-ba-SantaBarbara
 create mode 100644 dvbv5_isdb-t/br-ba-SantaCruzCabralia
 create mode 100644 dvbv5_isdb-t/br-ba-SantaMariaDaVitoria
 create mode 100644 dvbv5_isdb-t/br-ba-Santanopolis
 create mode 100644 dvbv5_isdb-t/br-ba-SantoAmaro
 create mode 100644 dvbv5_isdb-t/br-ba-SantoAntonioDeJesus
 create mode 100644 dvbv5_isdb-t/br-ba-SantoEstevao
 create mode 100644 dvbv5_isdb-t/br-ba-SaoFranciscoDoConde
 create mode 100644 dvbv5_isdb-t/br-ba-SaoGoncaloDosCampos
 create mode 100644 dvbv5_isdb-t/br-ba-SaoSebastiaoDoPasse
 create mode 100644 dvbv5_isdb-t/br-ba-SenhorDoBonfim
 create mode 100644 dvbv5_isdb-t/br-ba-SerraPreta
 create mode 100644 dvbv5_isdb-t/br-ba-Serrinha
 create mode 100644 dvbv5_isdb-t/br-ba-SimoesFilho
 create mode 100644 dvbv5_isdb-t/br-ba-Tanquinho
 create mode 100644 dvbv5_isdb-t/br-ba-TeixeiraDeFreitas
 create mode 100644 dvbv5_isdb-t/br-ba-Teofilandia
 create mode 100644 dvbv5_isdb-t/br-ba-Tremedal
 create mode 100644 dvbv5_isdb-t/br-ba-VeraCruz
 create mode 100644 dvbv5_isdb-t/br-ba-VitoriaDaConquista
 create mode 100644 dvbv5_isdb-t/br-ba-Xiquexique

diff --git a/dvbv5_isdb-t/br-ba-Alagoinhas b/dvbv5_isdb-t/br-ba-Alagoinhas
new file mode 100644
index 000000000000..1cde650ee369
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Alagoinhas
@@ -0,0 +1,61 @@
+# Channel table for Alagoinhas - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=479
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Alcobaca b/dvbv5_isdb-t/br-ba-Alcobaca
new file mode 100644
index 000000000000..1bd719c86af1
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Alcobaca
@@ -0,0 +1,32 @@
+# Channel table for Alcobaça - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=724
+
+# Physical channel 40
+[TV Sul Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Amargosa b/dvbv5_isdb-t/br-ba-Amargosa
new file mode 100644
index 000000000000..fc047f0ae731
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Amargosa
@@ -0,0 +1,32 @@
+# Channel table for Amargosa - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1345
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
diff --git a/dvbv5_isdb-t/br-ba-AmeliaRodrigues b/dvbv5_isdb-t/br-ba-AmeliaRodrigues
new file mode 100644
index 000000000000..16ac715ac834
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-AmeliaRodrigues
@@ -0,0 +1,206 @@
+# Channel table for Amélia Rodrigues - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3080
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia, TV Brasil]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 27
+[TV Subaé]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Anguera b/dvbv5_isdb-t/br-ba-Anguera
new file mode 100644
index 000000000000..d1b856bddbd9
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Anguera
@@ -0,0 +1,61 @@
+# Channel table for Anguera - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3119
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-AntonioCardoso b/dvbv5_isdb-t/br-ba-AntonioCardoso
new file mode 100644
index 000000000000..6cf4b3bc72af
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-AntonioCardoso
@@ -0,0 +1,61 @@
+# Channel table for Antonio Cardoso - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3120
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Aracatu b/dvbv5_isdb-t/br-ba-Aracatu
new file mode 100644
index 000000000000..d78715a2f48b
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Aracatu
@@ -0,0 +1,32 @@
+# Channel table for Aracatu - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1530
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Barra b/dvbv5_isdb-t/br-ba-Barra
new file mode 100644
index 000000000000..88a35b766c80
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Barra
@@ -0,0 +1,32 @@
+# Channel table for Barra - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=789
+
+# Physical channel 29
+[TV Oeste]
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
diff --git a/dvbv5_isdb-t/br-ba-BarraDoChoca b/dvbv5_isdb-t/br-ba-BarraDoChoca
new file mode 100644
index 000000000000..b27d6b05811a
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-BarraDoChoca
@@ -0,0 +1,61 @@
+# Channel table for Barra do Choça - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1370
+
+# Physical channel 28
+[TV Sudoeste]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
diff --git a/dvbv5_isdb-t/br-ba-Barreiras b/dvbv5_isdb-t/br-ba-Barreiras
new file mode 100644
index 000000000000..a188fcf611b4
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Barreiras
@@ -0,0 +1,61 @@
+# Channel table for Barreiras - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=192
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
+# Physical channel 29
+[TV Oeste]
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
diff --git a/dvbv5_isdb-t/br-ba-BeloCampo b/dvbv5_isdb-t/br-ba-BeloCampo
new file mode 100644
index 000000000000..d14f44122d95
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-BeloCampo
@@ -0,0 +1,61 @@
+# Channel table for Belo Campo - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1254
+
+# Physical channel 28
+[TV Sudoeste]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
diff --git a/dvbv5_isdb-t/br-ba-Biritinga b/dvbv5_isdb-t/br-ba-Biritinga
new file mode 100644
index 000000000000..85d294bc221a
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Biritinga
@@ -0,0 +1,32 @@
+# Channel table for Biritinga - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1255
+
+# Physical channel 30
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-BomJesusDaLapa b/dvbv5_isdb-t/br-ba-BomJesusDaLapa
new file mode 100644
index 000000000000..dbf9dd4d5b60
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-BomJesusDaLapa
@@ -0,0 +1,32 @@
+# Channel table for Bom Jesus da Lapa - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1373
+
+# Physical channel 29
+[TV Oeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Brumado b/dvbv5_isdb-t/br-ba-Brumado
new file mode 100644
index 000000000000..089a2de1e4bf
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Brumado
@@ -0,0 +1,32 @@
+# Channel table for Brumado - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=858
+
+# Physical channel 30
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Caetite b/dvbv5_isdb-t/br-ba-Caetite
new file mode 100644
index 000000000000..0921de0ee785
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Caetite
@@ -0,0 +1,32 @@
+# Channel table for Caetité - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=326
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Camacari b/dvbv5_isdb-t/br-ba-Camacari
new file mode 100644
index 000000000000..ca5cf087c520
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Camacari
@@ -0,0 +1,177 @@
+# Channel table for Camaçari - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=328
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-CampoFormoso b/dvbv5_isdb-t/br-ba-CampoFormoso
new file mode 100644
index 000000000000..e31b8434756e
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-CampoFormoso
@@ -0,0 +1,32 @@
+# Channel table for Campo Formoso - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1280
+
+# Physical channel 30
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-Candeal b/dvbv5_isdb-t/br-ba-Candeal
new file mode 100644
index 000000000000..58f170b44096
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Candeal
@@ -0,0 +1,61 @@
+# Channel table for Candeal - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3121
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Candeias b/dvbv5_isdb-t/br-ba-Candeias
new file mode 100644
index 000000000000..e0f5aab24b71
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Candeias
@@ -0,0 +1,177 @@
+# Channel table for Candeias - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3093
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-CandidoSales b/dvbv5_isdb-t/br-ba-CandidoSales
new file mode 100644
index 000000000000..c7a70945e1b7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-CandidoSales
@@ -0,0 +1,32 @@
+# Channel table for Cândido Sales - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1282
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Caraibas b/dvbv5_isdb-t/br-ba-Caraibas
new file mode 100644
index 000000000000..92ff8c1a9116
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Caraibas
@@ -0,0 +1,32 @@
+# Channel table for Caraíbas - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1286
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-ConceicaoDaFeira b/dvbv5_isdb-t/br-ba-ConceicaoDaFeira
new file mode 100644
index 000000000000..756801ca42b1
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-ConceicaoDaFeira
@@ -0,0 +1,32 @@
+# Channel table for Conceição da Feira - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1291
+
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-ConceicaoDoJacuipe b/dvbv5_isdb-t/br-ba-ConceicaoDoJacuipe
new file mode 100644
index 000000000000..9959ff91d8c2
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-ConceicaoDoJacuipe
@@ -0,0 +1,32 @@
+# Channel table for Conceição do Jacuípe - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1292
+
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-CoracaoDeMaria b/dvbv5_isdb-t/br-ba-CoracaoDeMaria
new file mode 100644
index 000000000000..0e3224280b95
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-CoracaoDeMaria
@@ -0,0 +1,61 @@
+# Channel table for Coração de Maria - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3122
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-CruzDasAlmas b/dvbv5_isdb-t/br-ba-CruzDasAlmas
new file mode 100644
index 000000000000..476669144ae8
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-CruzDasAlmas
@@ -0,0 +1,235 @@
+# Channel table for Cruz das Almas - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=432
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 27
+[TV Subaé]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-DiasDAvila b/dvbv5_isdb-t/br-ba-DiasDAvila
new file mode 100644
index 000000000000..6ee2fd1892f7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-DiasDAvila
@@ -0,0 +1,177 @@
+# Channel table for Dias d´ Ávila - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3094
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-EntreRios b/dvbv5_isdb-t/br-ba-EntreRios
new file mode 100644
index 000000000000..59b8db1ec5df
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-EntreRios
@@ -0,0 +1,32 @@
+# Channel table for Entre Rios - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1295
+
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Eunapolis b/dvbv5_isdb-t/br-ba-Eunapolis
new file mode 100644
index 000000000000..bf2384e6decb
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Eunapolis
@@ -0,0 +1,32 @@
+# Channel table for Eunápolis - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=557
+
+# Physical channel 30
+[TV Santa Cruz]
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
diff --git a/dvbv5_isdb-t/br-ba-FeiraDeSantana b/dvbv5_isdb-t/br-ba-FeiraDeSantana
new file mode 100644
index 000000000000..c3c2cf7f7609
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-FeiraDeSantana
@@ -0,0 +1,61 @@
+# Channel table for Feira de Santana - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=18
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Guanambi b/dvbv5_isdb-t/br-ba-Guanambi
new file mode 100644
index 000000000000..3b51c42cdaba
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Guanambi
@@ -0,0 +1,32 @@
+# Channel table for Guanambi - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=293
+
+# Physical channel 30
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Ichu b/dvbv5_isdb-t/br-ba-Ichu
new file mode 100644
index 000000000000..e736b7a8c07e
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Ichu
@@ -0,0 +1,32 @@
+# Channel table for Ichu - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=385
+
+# Physical channel 30
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Ilheus b/dvbv5_isdb-t/br-ba-Ilheus
new file mode 100644
index 000000000000..22f45a5b54c0
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Ilheus
@@ -0,0 +1,32 @@
+# Channel table for Ilhéus - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1379
+
+# Physical channel 28
+[TV Santa Cruz]
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
diff --git a/dvbv5_isdb-t/br-ba-Inhambupe b/dvbv5_isdb-t/br-ba-Inhambupe
new file mode 100644
index 000000000000..755a520621e6
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Inhambupe
@@ -0,0 +1,32 @@
+# Channel table for Inhambupe - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1309
+
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Ipecaeta b/dvbv5_isdb-t/br-ba-Ipecaeta
new file mode 100644
index 000000000000..c3aaeff33c0a
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Ipecaeta
@@ -0,0 +1,61 @@
+# Channel table for Ipecaetá - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3123
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Irara b/dvbv5_isdb-t/br-ba-Irara
new file mode 100644
index 000000000000..987ac6a19272
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Irara
@@ -0,0 +1,61 @@
+# Channel table for Irará - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3124
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Irece b/dvbv5_isdb-t/br-ba-Irece
new file mode 100644
index 000000000000..55e8c78f759e
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Irece
@@ -0,0 +1,61 @@
+# Channel table for Irecê - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1533
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
+# Physical channel 28
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-Itabuna b/dvbv5_isdb-t/br-ba-Itabuna
new file mode 100644
index 000000000000..5f695fdce523
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Itabuna
@@ -0,0 +1,32 @@
+# Channel table for Itabuna - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=144
+
+# Physical channel 30
+[TV Santa Cruz]
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
diff --git a/dvbv5_isdb-t/br-ba-Itamaraju b/dvbv5_isdb-t/br-ba-Itamaraju
new file mode 100644
index 000000000000..707b5f3bc72b
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Itamaraju
@@ -0,0 +1,61 @@
+# Channel table for Itamaraju - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1241
+
+# Physical channel 28
+[TV Santa Cruz]
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
+[TV Sul Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Itambe b/dvbv5_isdb-t/br-ba-Itambe
new file mode 100644
index 000000000000..899aae3deb0f
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Itambe
@@ -0,0 +1,32 @@
+# Channel table for Itambé - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2528
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Itaparica b/dvbv5_isdb-t/br-ba-Itaparica
new file mode 100644
index 000000000000..1f69529e7cef
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Itaparica
@@ -0,0 +1,148 @@
+# Channel table for Itaparica - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3098
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Itapetinga b/dvbv5_isdb-t/br-ba-Itapetinga
new file mode 100644
index 000000000000..330bc13405f5
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Itapetinga
@@ -0,0 +1,32 @@
+# Channel table for Itapetinga - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=743
+
+# Physical channel 27
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Jacobina b/dvbv5_isdb-t/br-ba-Jacobina
new file mode 100644
index 000000000000..4f30e57ca3b3
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Jacobina
@@ -0,0 +1,32 @@
+# Channel table for Jacobina - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=511
+
+# Physical channel 28
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-Jaguaquara b/dvbv5_isdb-t/br-ba-Jaguaquara
new file mode 100644
index 000000000000..dc15ea18eb61
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Jaguaquara
@@ -0,0 +1,32 @@
+# Channel table for Jaguaquara - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=775
+
+# Physical channel 30
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Jaguaripe b/dvbv5_isdb-t/br-ba-Jaguaripe
new file mode 100644
index 000000000000..029511ad54f7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Jaguaripe
@@ -0,0 +1,148 @@
+# Channel table for Jaguaripe - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1436
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Jequie b/dvbv5_isdb-t/br-ba-Jequie
new file mode 100644
index 000000000000..0b209179ce27
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Jequie
@@ -0,0 +1,32 @@
+# Channel table for Jequié - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=387
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Juazeiro b/dvbv5_isdb-t/br-ba-Juazeiro
new file mode 100644
index 000000000000..b35b7033462c
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Juazeiro
@@ -0,0 +1,90 @@
+# Channel table for Juazeiro - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=171
+
+# Physical channel 18
+[TV Grande Rio]
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
+# Physical channel 28
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-LauroDeFreitas b/dvbv5_isdb-t/br-ba-LauroDeFreitas
new file mode 100644
index 000000000000..e942c3aaf549
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-LauroDeFreitas
@@ -0,0 +1,177 @@
+# Channel table for Lauro de Freitas - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3089
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-LuisEduardoMagalhaes b/dvbv5_isdb-t/br-ba-LuisEduardoMagalhaes
new file mode 100644
index 000000000000..b92c2dcd01e7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-LuisEduardoMagalhaes
@@ -0,0 +1,32 @@
+# Channel table for Luís Eduardo Magalhães - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1365
+
+# Physical channel 30
+[TV Oeste]
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
diff --git a/dvbv5_isdb-t/br-ba-MadreDeDeus b/dvbv5_isdb-t/br-ba-MadreDeDeus
new file mode 100644
index 000000000000..e47c2e75a9df
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-MadreDeDeus
@@ -0,0 +1,177 @@
+# Channel table for Madre de Deus - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3101
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Maragogipe b/dvbv5_isdb-t/br-ba-Maragogipe
new file mode 100644
index 000000000000..e1b0abfce1c6
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Maragogipe
@@ -0,0 +1,148 @@
+# Channel table for Maragogipe - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1445
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-MataDeSaoJoao b/dvbv5_isdb-t/br-ba-MataDeSaoJoao
new file mode 100644
index 000000000000..91ba6db13d25
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-MataDeSaoJoao
@@ -0,0 +1,177 @@
+# Channel table for Mata de São João - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3102
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Nazare b/dvbv5_isdb-t/br-ba-Nazare
new file mode 100644
index 000000000000..c5d80d198c29
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Nazare
@@ -0,0 +1,177 @@
+# Channel table for Nazaré - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3109
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-PauloAfonso b/dvbv5_isdb-t/br-ba-PauloAfonso
new file mode 100644
index 000000000000..f200afd4077a
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-PauloAfonso
@@ -0,0 +1,32 @@
+# Channel table for Paulo Afonso - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=261
+
+# Physical channel 28
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-Piripa b/dvbv5_isdb-t/br-ba-Piripa
new file mode 100644
index 000000000000..dfb4f520c16d
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Piripa
@@ -0,0 +1,32 @@
+# Channel table for Piripá - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=2604
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Planalto b/dvbv5_isdb-t/br-ba-Planalto
new file mode 100644
index 000000000000..3aedf048bd25
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Planalto
@@ -0,0 +1,32 @@
+# Channel table for Planalto - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1498
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Pocoes b/dvbv5_isdb-t/br-ba-Pocoes
new file mode 100644
index 000000000000..8db4e2a2aeb1
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Pocoes
@@ -0,0 +1,32 @@
+# Channel table for Poções - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1359
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Pojuca b/dvbv5_isdb-t/br-ba-Pojuca
new file mode 100644
index 000000000000..bf0c5dfa7ef4
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Pojuca
@@ -0,0 +1,177 @@
+# Channel table for Pojuca - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1486
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-PortoSeguro b/dvbv5_isdb-t/br-ba-PortoSeguro
new file mode 100644
index 000000000000..d61c96bc639a
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-PortoSeguro
@@ -0,0 +1,32 @@
+# Channel table for Porto Seguro - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=159
+
+# Physical channel 29
+[TV Santa Cruz]
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
diff --git a/dvbv5_isdb-t/br-ba-PresidenteJanioQuadros b/dvbv5_isdb-t/br-ba-PresidenteJanioQuadros
new file mode 100644
index 000000000000..109c938880dc
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-PresidenteJanioQuadros
@@ -0,0 +1,32 @@
+# Channel table for Presidente Jânio Quadros - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1500
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-RafaelJambeiro b/dvbv5_isdb-t/br-ba-RafaelJambeiro
new file mode 100644
index 000000000000..46c14d396fd7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-RafaelJambeiro
@@ -0,0 +1,32 @@
+# Channel table for Rafael Jambeiro - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3245
+
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SalinasDaMargarida b/dvbv5_isdb-t/br-ba-SalinasDaMargarida
new file mode 100644
index 000000000000..f4a8cc60cc45
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SalinasDaMargarida
@@ -0,0 +1,177 @@
+# Channel table for Salinas da Margarida - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3112
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Salvador b/dvbv5_isdb-t/br-ba-Salvador
new file mode 100644
index 000000000000..cf4eb9007b0c
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Salvador
@@ -0,0 +1,177 @@
+# Channel table for Salvador - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=19
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia HD, TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-SantaBarbara b/dvbv5_isdb-t/br-ba-SantaBarbara
new file mode 100644
index 000000000000..bd76431f5dee
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantaBarbara
@@ -0,0 +1,61 @@
+# Channel table for Santa Bárbara - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3125
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SantaCruzCabralia b/dvbv5_isdb-t/br-ba-SantaCruzCabralia
new file mode 100644
index 000000000000..05ce784e1ab5
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantaCruzCabralia
@@ -0,0 +1,32 @@
+# Channel table for Santa Cruz Cabrália - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1488
+
+# Physical channel 29
+[TV Santa Cruz]
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
diff --git a/dvbv5_isdb-t/br-ba-SantaMariaDaVitoria b/dvbv5_isdb-t/br-ba-SantaMariaDaVitoria
new file mode 100644
index 000000000000..6ef7a1749fc5
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantaMariaDaVitoria
@@ -0,0 +1,32 @@
+# Channel table for Santa Maria da Vitória - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1352
+
+# Physical channel 28
+[TV Oeste]
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
diff --git a/dvbv5_isdb-t/br-ba-Santanopolis b/dvbv5_isdb-t/br-ba-Santanopolis
new file mode 100644
index 000000000000..2a924f398d35
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Santanopolis
@@ -0,0 +1,61 @@
+# Channel table for Santanópolis - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3127
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SantoAmaro b/dvbv5_isdb-t/br-ba-SantoAmaro
new file mode 100644
index 000000000000..852bc82fe4c0
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantoAmaro
@@ -0,0 +1,177 @@
+# Channel table for Santo Amaro - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3090
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-SantoAntonioDeJesus b/dvbv5_isdb-t/br-ba-SantoAntonioDeJesus
new file mode 100644
index 000000000000..e342d1d6ea51
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantoAntonioDeJesus
@@ -0,0 +1,177 @@
+# Channel table for Santo Antônio de Jesus - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=722
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-SantoEstevao b/dvbv5_isdb-t/br-ba-SantoEstevao
new file mode 100644
index 000000000000..b1b8dfed7ef4
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SantoEstevao
@@ -0,0 +1,61 @@
+# Channel table for Santo Estêvão - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3099
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SaoFranciscoDoConde b/dvbv5_isdb-t/br-ba-SaoFranciscoDoConde
new file mode 100644
index 000000000000..e49183bf7689
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SaoFranciscoDoConde
@@ -0,0 +1,177 @@
+# Channel table for São Francisco do Conde - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3104
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-SaoGoncaloDosCampos b/dvbv5_isdb-t/br-ba-SaoGoncaloDosCampos
new file mode 100644
index 000000000000..d1ca71fc941c
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SaoGoncaloDosCampos
@@ -0,0 +1,61 @@
+# Channel table for São Gonçalo dos Campos - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3128
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SaoSebastiaoDoPasse b/dvbv5_isdb-t/br-ba-SaoSebastiaoDoPasse
new file mode 100644
index 000000000000..1164147c1785
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SaoSebastiaoDoPasse
@@ -0,0 +1,206 @@
+# Channel table for São Sebastião do Passé - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3108
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 27
+[TV Subaé]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-SenhorDoBonfim b/dvbv5_isdb-t/br-ba-SenhorDoBonfim
new file mode 100644
index 000000000000..c3610c832842
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SenhorDoBonfim
@@ -0,0 +1,32 @@
+# Channel table for Senhor do Bonfim - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=669
+
+# Physical channel 28
+[TV São Francisco]
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
diff --git a/dvbv5_isdb-t/br-ba-SerraPreta b/dvbv5_isdb-t/br-ba-SerraPreta
new file mode 100644
index 000000000000..5256c62dfb46
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SerraPreta
@@ -0,0 +1,61 @@
+# Channel table for Serra Preta - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3129
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Serrinha b/dvbv5_isdb-t/br-ba-Serrinha
new file mode 100644
index 000000000000..11284d042e19
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Serrinha
@@ -0,0 +1,32 @@
+# Channel table for Serrinha - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=633
+
+# Physical channel 30
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-SimoesFilho b/dvbv5_isdb-t/br-ba-SimoesFilho
new file mode 100644
index 000000000000..10775fef1b49
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-SimoesFilho
@@ -0,0 +1,177 @@
+# Channel table for Simões Filho - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3110
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Tanquinho b/dvbv5_isdb-t/br-ba-Tanquinho
new file mode 100644
index 000000000000..b1864163d3c4
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Tanquinho
@@ -0,0 +1,61 @@
+# Channel table for Tanquinho - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3130
+
+# Physical channel 14
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 473142857
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
+# Physical channel 27
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-TeixeiraDeFreitas b/dvbv5_isdb-t/br-ba-TeixeiraDeFreitas
new file mode 100644
index 000000000000..e095b38de426
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-TeixeiraDeFreitas
@@ -0,0 +1,61 @@
+# Channel table for Teixeira de Freitas - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=668
+
+# Physical channel 30
+[TV Santa Cruz]
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
+# Physical channel 40
+[TV Sul Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-Teofilandia b/dvbv5_isdb-t/br-ba-Teofilandia
new file mode 100644
index 000000000000..168e38b066e7
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Teofilandia
@@ -0,0 +1,32 @@
+# Channel table for Teofilândia - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1546
+
+# Physical channel 30
+[TV Subaé]
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
diff --git a/dvbv5_isdb-t/br-ba-Tremedal b/dvbv5_isdb-t/br-ba-Tremedal
new file mode 100644
index 000000000000..054f736266a5
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Tremedal
@@ -0,0 +1,32 @@
+# Channel table for Tremedal - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1547
+
+# Physical channel 28
+[TV Sudoeste]
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
diff --git a/dvbv5_isdb-t/br-ba-VeraCruz b/dvbv5_isdb-t/br-ba-VeraCruz
new file mode 100644
index 000000000000..fb15bea06516
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-VeraCruz
@@ -0,0 +1,177 @@
+# Channel table for Vera Cruz - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=3111
+
+# Physical channel 21
+[Record Bahia]
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
+# Physical channel 24
+[TVE Bahia]
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
+# Physical channel 25
+[TV Aratu]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
+[Band Bahia]
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
diff --git a/dvbv5_isdb-t/br-ba-VitoriaDaConquista b/dvbv5_isdb-t/br-ba-VitoriaDaConquista
new file mode 100644
index 000000000000..888eeff6243f
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-VitoriaDaConquista
@@ -0,0 +1,61 @@
+# Channel table for Vitória da Conquista - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=605
+
+# Physical channel 28
+[TV Sudoeste]
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
+# Physical channel 43
+[Rede Vida]
+	DELIVERY_SYSTEM = ISDBT
+	BANDWIDTH_HZ = 6000000
+	FREQUENCY = 647142857
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
diff --git a/dvbv5_isdb-t/br-ba-Xiquexique b/dvbv5_isdb-t/br-ba-Xiquexique
new file mode 100644
index 000000000000..cb31ffb5bad8
--- /dev/null
+++ b/dvbv5_isdb-t/br-ba-Xiquexique
@@ -0,0 +1,32 @@
+# Channel table for Xique-Xique - BA - Brazil
+# Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=512
+
+# Physical channel 30
+[TV Oeste]
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
-- 
1.9.3

