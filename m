Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp19.orange.fr ([80.12.242.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KrH5I-0004MF-R3
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 21:03:37 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1926.orange.fr (SMTP Server) with ESMTP id 0F3951C0008F
	for <linux-dvb@linuxtv.org>; Sat, 18 Oct 2008 21:02:59 +0200 (CEST)
Received: from [10.0.0.1] (ANantes-256-1-120-135.w90-1.abo.wanadoo.fr
	[90.1.247.135])
	by mwinf1926.orange.fr (SMTP Server) with ESMTP id 713D71C0008C
	for <linux-dvb@linuxtv.org>; Sat, 18 Oct 2008 21:02:58 +0200 (CEST)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Sat, 18 Oct 2008 21:02:50 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_aLj+IqO05s+/nIU"
Message-Id: <200810182102.50898.hftom@free.fr>
Subject: [linux-dvb] kaffeine s2api v2 patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_aLj+IqO05s+/nIU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

If anyone is interested.
Applies to kaffeine svn.

-- 
Christophe Thommeret

--Boundary-00=_aLj+IqO05s+/nIU
Content-Type: text/x-diff;
  charset="utf-8";
  name="kaffeine-s2api-v2.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kaffeine-s2api-v2.diff"

Index: src/player-parts/xine-part/kxinewidget.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/player-parts/xine-part/kxinewidget.cpp	(r=C3=A9vision 863489)
+++ src/player-parts/xine-part/kxinewidget.cpp	(copie de travail)
@@ -1858,7 +1858,7 @@
=20
 void KXineWidget::setDvb( const QString &pipeName, const QString &chanName=
, int haveVideo )
 {
=2D	m_trackURL =3D pipeName;
+	m_trackURL =3D /*"fifo://"+*/pipeName;
 	m_trackTitle =3D chanName;
 	dvbHaveVideo =3D haveVideo;
 }
@@ -1875,7 +1875,7 @@
 	clearQueue();
 	m_lengthInfoTimer.stop();
 	m_posTimer.stop();
=2D	xine_set_param( m_xineStream, XINE_PARAM_METRONOM_PREBUFFER, 180000);
+	xine_set_param( m_xineStream, XINE_PARAM_METRONOM_PREBUFFER, 90000);
 	if (!xine_open(m_xineStream, QFile::encodeName(m_trackURL))) {
 		sendXineError();
 		return false;
Index: src/kaffeine.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/kaffeine.cpp	(r=C3=A9vision 863489)
+++ src/kaffeine.cpp	(copie de travail)
@@ -307,8 +307,10 @@
 	}
 	loadTMP(urls);
=20
=2D	if (args->isSet("fullscreen"))
+	if (args->isSet("fullscreen")) {
+		inplug->showPlayer();
 		fullscreen();
+	}
=20
 	if (args->isSet("minimal"))
 		minimal();
@@ -1210,8 +1212,6 @@
 			inplug->fullscreen( false );
 		}
=20
=2D		inplug->showPlayer();
=2D
 		if (m_haveKWin)
 			KWin::clearState(winId(), NET::FullScreen);
 		else
Index: src/input/dvb/channeleditorui.ui
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/channeleditorui.ui	(r=C3=A9vision 863489)
+++ src/input/dvb/channeleditorui.ui	(copie de travail)
@@ -9,7 +9,7 @@
             <x>0</x>
             <y>0</y>
             <width>477</width>
=2D            <height>533</height>
+            <height>541</height>
         </rect>
     </property>
     <property name=3D"caption">
@@ -19,7 +19,7 @@
         <property name=3D"name">
             <cstring>unnamed</cstring>
         </property>
=2D        <widget class=3D"Line" row=3D"1" column=3D"0">
+        <widget class=3D"Line" row=3D"0" column=3D"1">
             <property name=3D"name">
                 <cstring>line2</cstring>
             </property>
@@ -35,7 +35,7 @@
         </widget>
         <widget class=3D"QLayoutWidget" row=3D"0" column=3D"0">
             <property name=3D"name">
=2D                <cstring>layout9</cstring>
+                <cstring>layout7</cstring>
             </property>
             <vbox>
                 <property name=3D"name">
@@ -432,22 +432,6 @@
                                 <cstring>transmissionComb</cstring>
                             </property>
                         </widget>
=2D                        <widget class=3D"QLabel" row=3D"3" column=3D"0">
=2D                            <property name=3D"name">
=2D                                <cstring>textLabel11</cstring>
=2D                            </property>
=2D                            <property name=3D"sizePolicy">
=2D                                <sizepolicy>
=2D                                    <hsizetype>4</hsizetype>
=2D                                    <vsizetype>5</vsizetype>
=2D                                    <horstretch>0</horstretch>
=2D                                    <verstretch>0</verstretch>
=2D                                </sizepolicy>
=2D                            </property>
=2D                            <property name=3D"text">
=2D                                <string>Bandwidth:</string>
=2D                            </property>
=2D                        </widget>
                         <widget class=3D"QLabel" row=3D"2" column=3D"0">
                             <property name=3D"name">
                                 <cstring>textLabel10</cstring>
@@ -480,11 +464,6 @@
                                 <string>Transmission:</string>
                             </property>
                         </widget>
=2D                        <widget class=3D"QComboBox" row=3D"3" column=3D"=
1">
=2D                            <property name=3D"name">
=2D                                <cstring>bandwidthComb</cstring>
=2D                            </property>
=2D                        </widget>
                         <widget class=3D"QComboBox" row=3D"2" column=3D"1">
                             <property name=3D"name">
                                 <cstring>coderateHComb</cstring>
@@ -511,11 +490,6 @@
                                 <string>FEC low:</string>
                             </property>
                         </widget>
=2D                        <widget class=3D"QComboBox" row=3D"3" column=3D"=
3">
=2D                            <property name=3D"name">
=2D                                <cstring>guardComb</cstring>
=2D                            </property>
=2D                        </widget>
                         <widget class=3D"QLabel" row=3D"3" column=3D"2">
                             <property name=3D"name">
                                 <cstring>textLabel7</cstring>
@@ -595,6 +569,58 @@
                                 <string>Inversion:</string>
                             </property>
                         </widget>
+                        <widget class=3D"QLabel" row=3D"3" column=3D"0">
+                            <property name=3D"name">
+                                <cstring>textLabel11</cstring>
+                            </property>
+                            <property name=3D"sizePolicy">
+                                <sizepolicy>
+                                    <hsizetype>4</hsizetype>
+                                    <vsizetype>5</vsizetype>
+                                    <horstretch>0</horstretch>
+                                    <verstretch>0</verstretch>
+                                </sizepolicy>
+                            </property>
+                            <property name=3D"text">
+                                <string>Bandwidth:</string>
+                            </property>
+                        </widget>
+                        <widget class=3D"QComboBox" row=3D"3" column=3D"1">
+                            <property name=3D"name">
+                                <cstring>bandwidthComb</cstring>
+                            </property>
+                        </widget>
+                        <widget class=3D"QLabel" row=3D"4" column=3D"0">
+                            <property name=3D"name">
+                                <cstring>textLabel1_3</cstring>
+                            </property>
+                            <property name=3D"text">
+                                <string>Type:</string>
+                            </property>
+                        </widget>
+                        <widget class=3D"QComboBox" row=3D"4" column=3D"1">
+                            <property name=3D"name">
+                                <cstring>stypeComb</cstring>
+                            </property>
+                        </widget>
+                        <widget class=3D"QComboBox" row=3D"4" column=3D"3">
+                            <property name=3D"name">
+                                <cstring>rolloffComb</cstring>
+                            </property>
+                        </widget>
+                        <widget class=3D"QLabel" row=3D"4" column=3D"2">
+                            <property name=3D"name">
+                                <cstring>textLabel2_4</cstring>
+                            </property>
+                            <property name=3D"text">
+                                <string>Roll off:</string>
+                            </property>
+                        </widget>
+                        <widget class=3D"QComboBox" row=3D"3" column=3D"3">
+                            <property name=3D"name">
+                                <cstring>guardComb</cstring>
+                            </property>
+                        </widget>
                     </grid>
                 </widget>
                 <spacer>
@@ -610,7 +636,7 @@
                     <property name=3D"sizeHint">
                         <size>
                             <width>20</width>
=2D                            <height>98</height>
+                            <height>166</height>
                         </size>
                     </property>
                 </spacer>
Index: src/input/dvb/channeldesc.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/channeldesc.h	(r=C3=A9vision 863489)
+++ src/input/dvb/channeldesc.h	(copie de travail)
@@ -101,6 +101,8 @@
 	fe_code_rate_t coderateH;
 	fe_bandwidth_t bandwidth;
 	int snr;
+	fe_rolloff_t rolloff;
+	char S2;
 };
=20
 class ChannelDesc
Index: src/input/dvb/dvbsi.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/dvbsi.h	(r=C3=A9vision 863489)
+++ src/input/dvb/dvbsi.h	(copie de travail)
@@ -36,6 +36,7 @@
 	bool getSection( int pid, int tid, int timeout=3D5000 );
 	bool tableNIT( unsigned char* buf );
 	void satelliteDesc( unsigned char* buf, Transponder *trans );
+	void S2satelliteDesc( unsigned char* buf, Transponder *trans );
 	void cableDesc( unsigned char* buf, Transponder *trans );
 	void terrestrialDesc( unsigned char* buf, Transponder *trans );
 	void freqListDesc( unsigned char* buf, Transponder *trans );
Index: src/input/dvb/channeleditor.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/channeleditor.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/channeleditor.cpp	(copie de travail)
@@ -143,6 +143,9 @@
 		else channel->tp.pol =3D 'h';
 		channel->tp.coderateH =3D (fe_code_rate_t)(FEC_NONE+coderateHComb->curre=
ntItem());
 		channel->tp.inversion =3D (fe_spectral_inversion_t)(INVERSION_OFF+invers=
ionComb->currentItem());
+		channel->tp.modulation =3D (fe_modulation_t)(QPSK+modulationComb->curren=
tItem());
+		channel->tp.S2 =3D stypeComb->currentItem();
+		channel->tp.rolloff =3D (fe_rolloff_t)(ROLLOFF_35+rolloffComb->currentIt=
em() );
 	}
 	else if ( channel->tp.type=3D=3DFE_QAM ) {
 		channel->tp.freq =3D freqSpin->value();
@@ -165,13 +168,7 @@
 	else {
 		channel->tp.freq =3D freqSpin->value();
 		channel->tp.inversion =3D (fe_spectral_inversion_t)(INVERSION_OFF+invers=
ionComb->currentItem());
=2D		switch (modulationComb->currentItem()) {
=2D		case 0: channel->tp.modulation =3D QAM_64; break;
=2D		case 1: channel->tp.modulation =3D QAM_256; break;
=2D		case 2: channel->tp.modulation =3D VSB_8; break;
=2D		case 3: channel->tp.modulation =3D VSB_16; break;
=2D		default: channel->tp.modulation =3D QAM_AUTO; break;
=2D		}
+		channel->tp.modulation =3D (fe_modulation_t)(QPSK+modulationComb->curren=
tItem());
 	}
=20
 	done( Accepted );
@@ -187,10 +184,15 @@
 	inversionComb->setCurrentItem( INVERSION_OFF+channel->tp.inversion );
 	coderateHComb->insertStringList( coderateList() );
 	coderateHComb->setCurrentItem( FEC_NONE+channel->tp.coderateH );
+	modulationComb->insertStringList( modulationList() );
+	modulationComb->setCurrentItem( QPSK+channel->tp.modulation );
+	stypeComb->insertStringList( stypeList() );
+	stypeComb->setCurrentItem( channel->tp.S2 );
+	rolloffComb->insertStringList( rolloffList() );
+	rolloffComb->setCurrentItem( ROLLOFF_35+channel->tp.rolloff );
 	transmissionComb->setEnabled( false );
 	coderateLComb->setEnabled( false );
 	bandwidthComb->setEnabled( false );
=2D	modulationComb->setEnabled( false );
 	hierarchyComb->setEnabled( false );
 	guardComb->setEnabled( false );
 }
@@ -211,6 +213,8 @@
 	bandwidthComb->setEnabled( false );
 	hierarchyComb->setEnabled( false );
 	guardComb->setEnabled( false );
+	stypeComb->setEnabled( false );
+	rolloffComb->setEnabled( false );
 }
=20
 void ChannelEditor::initT()
@@ -234,6 +238,8 @@
 	guardComb->setCurrentItem( GUARD_INTERVAL_1_32+channel->tp.guard );
 	srSpin->setEnabled( false );
 	polGroup->setEnabled( false );
+	stypeComb->setEnabled( false );
+	rolloffComb->setEnabled( false );
 }
=20
 void ChannelEditor::initA()
@@ -241,14 +247,8 @@
 	freqSpin->setValue( channel->tp.freq );
 	inversionComb->insertStringList( inversionList() );
 	inversionComb->setCurrentItem( INVERSION_OFF+channel->tp.inversion );
=2D	modulationComb->insertStringList( modulationListAtsc() );
=2D	switch (channel->tp.modulation) {
=2D	case QAM_64: modulationComb->setCurrentItem(0); break;
=2D	case QAM_256: modulationComb->setCurrentItem(1); break;
=2D	case VSB_8: modulationComb->setCurrentItem(2); break;
=2D	case VSB_16: modulationComb->setCurrentItem(3); break;
=2D	default: modulationComb->setCurrentItem(4); break;
=2D	}
+	modulationComb->insertStringList( modulationList() );
+	modulationComb->setCurrentItem( QPSK+channel->tp.modulation );
 	srSpin->setEnabled( false );
 	polGroup->setEnabled( false );
 	transmissionComb->setEnabled( false );
@@ -257,6 +257,8 @@
 	bandwidthComb->setEnabled( false );
 	hierarchyComb->setEnabled( false );
 	guardComb->setEnabled( false );
+	stypeComb->setEnabled( false );
+	rolloffComb->setEnabled( false );
 }
=20
 QStringList ChannelEditor::inversionList()
@@ -271,7 +273,7 @@
 {
 	QStringList list;
=20
=2D	list<<"NONE"<<"1/2"<<"2/3"<<"3/4"<<"4/5"<<"5/6"<<"6/7"<<"7/8"<<"8/9"<<"=
AUTO";
+	list<<"NONE"<<"1/2"<<"2/3"<<"3/4"<<"4/5"<<"5/6"<<"6/7"<<"7/8"<<"8/9"<<"AU=
TO"<<"3/5"<<"9/10";
 	return list;
 }
=20
@@ -279,18 +281,10 @@
 {
 	QStringList list;
=20
=2D	list<<"QPSK"<<"QAM 16"<<"QAM 32"<<"QAM 64"<<"QAM 128"<<"QAM 256"<<"AUTO=
";
+	list<<"QPSK"<<"QAM 16"<<"QAM 32"<<"QAM 64"<<"QAM 128"<<"QAM 256"<<"AUTO"<=
<"VSB-8"<<"VSB-16"<<"8PSK"<<"16APSK"<<"DQPSK";
 	return list;
 }
=20
=2DQStringList ChannelEditor::modulationListAtsc()
=2D{
=2D	QStringList list;
=2D
=2D	list<<"QAM 64"<<"QAM 256"<<"VSB 8"<<"VSB 16"<<"AUTO";
=2D	return list;
=2D}
=2D
 QStringList ChannelEditor::transmissionList()
 {
 	QStringList list;
@@ -323,6 +317,22 @@
 	return list;
 }
=20
+QStringList ChannelEditor::stypeList()
+{
+	QStringList list;
+
+	list<<"DVB-S"<<"DVB-S2";
+	return list;
+}
+
+QStringList ChannelEditor::rolloffList()
+{
+	QStringList list;
+
+	list<<"35"<<"20"<<"25"<<"AUTO";
+	return list;
+}
+
 ChannelEditor::~ChannelEditor()
 {
 }
Index: src/input/dvb/plugins/epg/kaffeinedvbsection.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/plugins/epg/kaffeinedvbsection.cpp	(r=C3=A9vision 86348=
9)
+++ src/input/dvb/plugins/epg/kaffeinedvbsection.cpp	(copie de travail)
@@ -141,6 +141,9 @@
 	if ( inSize<1 )
 		return false;
 	cd =3D iconv_open( "UTF8", table );
+	//check if charset unknown
+	if( cd =3D=3D (iconv_t)(-1) )
+		return false;
 	inBuf =3D s.data();
 	outBuf =3D buffer;
 	outBuf[0] =3D 0;
Index: src/input/dvb/dvbconfig.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/dvbconfig.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/dvbconfig.cpp	(copie de travail)
@@ -205,6 +205,8 @@
 	int i=3D0, j=3D0, res, fdFrontend=3D0;
 	struct dvb_frontend_info info;
 	bool as;
+	bool loop;
+	QTime t1;
=20
 	QStringList list, flist;
 	QString s, t;
@@ -218,25 +220,36 @@
 		for ( j=3D0; j<(int)flist.count(); j++ ) {
 			s =3D list[i];
 			t =3D flist[j];
=2D			fdFrontend =3D open( QString("/dev/dvb/%1/%2").arg( s ).arg( t ).asci=
i(), O_RDWR);
=2D			if ( fdFrontend>0 ) {
=2D				if ( !(res =3D ioctl( fdFrontend, FE_GET_INFO, &info ) < 0) ) {
=2D					if ( (info.type=3D=3DFE_OFDM)
=2D						&& (info.caps & FE_CAN_QAM_AUTO)
=2D						&& (info.caps & FE_CAN_TRANSMISSION_MODE_AUTO)
=2D						&& (info.caps & FE_CAN_GUARD_INTERVAL_AUTO)
=2D						&& (info.caps & FE_CAN_HIERARCHY_AUTO)
=2D						&& (info.caps & FE_CAN_FEC_AUTO) )
=2D						as =3D true;
=2D					else
=2D						as =3D false;
=2D					fprintf(stderr,"/dev/dvb/%s/%s : opened ( %s )\n", s.ascii(), t.asc=
ii(), info.name );
=2D					devList.append( new Device( s.replace("adapter","").toInt(), t.repl=
ace("frontend","").toInt(), info.type, info.name, as ) );
+			loop =3D true;
+			t1 =3D QTime::currentTime();
+			while ( loop ) {
+				fdFrontend =3D open( QString("/dev/dvb/%1/%2").arg( s ).arg( t ).ascii=
(), O_RDWR);
+				if ( fdFrontend>0 ) {
+					loop =3D false;
+					if ( !(res =3D ioctl( fdFrontend, FE_GET_INFO, &info ) < 0) ) {
+						if ( (info.type=3D=3DFE_OFDM)
+							&& (info.caps & FE_CAN_QAM_AUTO)
+							&& (info.caps & FE_CAN_TRANSMISSION_MODE_AUTO)
+							&& (info.caps & FE_CAN_GUARD_INTERVAL_AUTO)
+							&& (info.caps & FE_CAN_HIERARCHY_AUTO)
+							&& (info.caps & FE_CAN_FEC_AUTO) )
+							as =3D true;
+						else
+							as =3D false;
+						fprintf(stderr,"/dev/dvb/%s/%s : opened ( %s ) (%dms)\n", s.ascii(),=
 t.ascii(), info.name, t1.msecsTo(QTime::currentTime()) );
+						devList.append( new Device( s.replace("adapter","").toInt(), t.repla=
ce("frontend","").toInt(), info.type, info.name, as ) );
+					}
+					close( fdFrontend );
 				}
=2D				close( fdFrontend );
+				else {
+					/*if ( errno=3D=3DEBUSY && j>0 && t1.msecsTo(QTime::currentTime())<50=
00 ) {// exclusive frontends ?
+						usleep( 10000 );
+						continue;
+					}*/
+					perror( QString("/dev/dvb/%1/%2  %3/%4").arg( s ).arg( t ).arg( errno=
 ).arg( -EBUSY ).ascii() );
+					loop =3D false;
+				}
 			}
=2D			else
=2D				perror( QString("/dev/dvb/%1/%2").arg( s ).arg( t ).ascii() );
 		}
 	}
=20
Index: src/input/dvb/dvbsi.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/dvbsi.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/dvbsi.cpp	(copie de travail)
@@ -173,6 +173,9 @@
 					fprintf(stderr,"     Found frequency list.\n");
 					freqListDesc( buf, trans );
 					break;
+				case 0x79 :
+					S2satelliteDesc( buf, trans );
+					break;
 				default :
 					break;
 			}
@@ -226,22 +229,57 @@
 		trans->pol =3D 'v';
 	else
 		trans->pol =3D 'h';
+	switch ( getBits(buf,70,2) ) {
+		case 0 : trans->modulation =3D QAM_AUTO; break;
+		case 1 : trans->modulation =3D QPSK; break;
+		case 2 : trans->modulation =3D PSK_8; break;
+		case 3 : trans->modulation =3D QAM_16; break;
+	}
 	s =3D t.setNum( getBits(buf,72,28), 16 );
 	trans->sr =3D s.toInt();
 	trans->sr /=3D10;
 	switch ( getBits(buf,100,4) ) {
+		case 0 : trans->coderateH =3D FEC_AUTO; break;
 		case 1 : trans->coderateH =3D FEC_1_2; break;
 		case 2 : trans->coderateH =3D FEC_2_3; break;
 		case 3 : trans->coderateH =3D FEC_3_4; break;
 		case 4 : trans->coderateH =3D FEC_5_6; break;
 		case 5 : trans->coderateH =3D FEC_7_8; break;
 		case 6 : trans->coderateH =3D FEC_8_9; break;
=2D		case 7 : trans->coderateH =3D FEC_NONE; break;
+		case 7 : trans->coderateH =3D FEC_3_5; break;
+		case 8 : trans->coderateH =3D FEC_4_5; break;
+		case 9 : trans->coderateH =3D FEC_9_10; break;
+		case 15 : trans->coderateH =3D FEC_NONE; break;
 	}
+	if ( getBits(buf,69,1) ) {
+		fprintf(stderr,"!!!!!!!!!!!!!!!!!! Found S2 MODULATION SYSTEM !!!!!!!!!!=
!!!!!!!!!!!!!!!!!!!!\n");
+		trans->S2 =3D 1;
+		switch ( getBits(buf,67,2) ) {
+			case 0 : trans->rolloff =3D ROLLOFF_35; break;
+			case 1 : trans->rolloff =3D ROLLOFF_25; break;
+			case 2 : trans->rolloff =3D ROLLOFF_20; break;
+		}
+	}
 }
=20
=20
=20
+void NitSection::S2satelliteDesc( unsigned char* buf, Transponder *trans )
+{
+	fprintf(stderr,"!!!!!!!!!!!!!!!!!! Found S2 DESCRIPTOR !!!!!!!!!!!!!!!!!!=
!!!!!!!!!!!!\n");
+	int scrambling_sequence_selector =3D getBits(buf,16,1);
+	int multiple_input_stream_flag =3D getBits(buf,17,1);
+	int backwards_compatibility_indicator =3D getBits(buf,18,1);
+	int scrambling_sequence_index =3D 0;
+	if ( scrambling_sequence_selector )
+		scrambling_sequence_index =3D getBits(buf,30,18);
+	int input_stream_identifier =3D 0;
+	if ( multiple_input_stream_flag )
+		input_stream_identifier =3D getBits(buf,48,8);
+}
+
+
+
 void NitSection::cableDesc( unsigned char* buf, Transponder *trans )
 {
 	QString s, t;
@@ -261,13 +299,17 @@
 	trans->sr =3D s.toInt();
 	trans->sr /=3D10;
 	switch ( getBits(buf,100,4) ) {
+		case 0 : trans->coderateH =3D FEC_AUTO; break;
 		case 1 : trans->coderateH =3D FEC_1_2; break;
 		case 2 : trans->coderateH =3D FEC_2_3; break;
 		case 3 : trans->coderateH =3D FEC_3_4; break;
 		case 4 : trans->coderateH =3D FEC_5_6; break;
 		case 5 : trans->coderateH =3D FEC_7_8; break;
 		case 6 : trans->coderateH =3D FEC_8_9; break;
=2D		case 7 : trans->coderateH =3D FEC_NONE; break;
+		case 7 : trans->coderateH =3D FEC_3_5; break;
+		case 8 : trans->coderateH =3D FEC_4_5; break;
+		case 9 : trans->coderateH =3D FEC_9_10; break;
+		case 15 : trans->coderateH =3D FEC_NONE; break;
 	}
 }
=20
Index: src/input/dvb/channeldesc.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/channeldesc.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/channeldesc.cpp	(copie de travail)
@@ -115,6 +115,8 @@
 	coderateH=3DFEC_AUTO;
 	bandwidth=3DBANDWIDTH_AUTO;
 	snr =3D 0;
+	rolloff =3D ROLLOFF_AUTO;
+	S2 =3D 0;
 }
=20
 Transponder::Transponder( const Transponder &trans )
@@ -134,6 +136,8 @@
 	coderateL=3Dtrans.coderateL;
 	coderateH=3Dtrans.coderateH;
 	bandwidth=3Dtrans.bandwidth;
+	rolloff =3D trans.rolloff;
+	S2 =3D trans.S2;
 }
=20
 bool Transponder::sameAs( Transponder *trans )
Index: src/input/dvb/channeleditor.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/channeleditor.h	(r=C3=A9vision 863489)
+++ src/input/dvb/channeleditor.h	(copie de travail)
@@ -53,11 +53,12 @@
 	QStringList inversionList();
 	QStringList coderateList();
 	QStringList modulationList();
=2D	QStringList modulationListAtsc();
 	QStringList transmissionList();
 	QStringList bandwidthList();
 	QStringList hierarchyList();
 	QStringList guardList();
+	QStringList stypeList();
+	QStringList rolloffList();
=20
 	ChannelDesc *channel;
 	QPtrList<ChannelDesc> *chandesc;
Index: src/input/dvb/dvbstream.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/dvbstream.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/dvbstream.cpp	(copie de travail)
@@ -185,7 +185,7 @@
 		fprintf(stderr,"openFe: fdFrontend !=3D 0\n");
 		return false;
 	}
=2D	fdFrontend =3D open( frontendName.ascii(), O_RDWR );
+	fdFrontend =3D open( frontendName.ascii(), O_RDWR /*| O_NONBLOCK*/ );
 	if ( fdFrontend<0 ) {
 		perror("openFe:");
 		fdFrontend =3D 0;
@@ -319,7 +319,6 @@
 {
 	unsigned long lof=3D0;
 	int res, hiband=3D0;
=2D	struct dvb_frontend_parameters feparams;
 	struct dvb_frontend_info fe_info;
 	fe_status_t status;
 	unsigned long freq=3Dchan->tp.freq;
@@ -328,6 +327,11 @@
 	int rotorMove =3D 0;
 	int loop=3D0, i;
=20
+	struct dtv_property cmdargs[20];
+	struct dtv_properties cmdseq;
+	int inversion;
+	int bandwidth;
+
 	closeFe();
 	if ( !openFe() )
 		return false;
@@ -344,18 +348,43 @@
 	freq*=3D1000;
 	srate*=3D1000;
=20
+	QTime t1 =3D QTime::currentTime();
+	QTime t2;
+
+	if ( chan->tp.inversion=3D=3DINVERSION_AUTO ) {
+		if ( fe_info.caps & FE_CAN_INVERSION_AUTO )
+			inversion =3D chan->tp.inversion;
+		else {
+			fprintf(stderr,"Can NOT inversion_auto\n");
+			inversion =3D INVERSION_OFF;
+		}
+	}
+	else
+		inversion=3Dchan->tp.inversion;
+
 	switch( fe_info.type ) {
 		case FE_OFDM : {
 			if (freq < 1000000)
 				freq*=3D1000UL;
=2D			feparams.frequency=3Dfreq;
=2D			feparams.u.ofdm.bandwidth=3Dchan->tp.bandwidth;
=2D			feparams.u.ofdm.code_rate_HP=3Dchan->tp.coderateH;
=2D			feparams.u.ofdm.code_rate_LP=3Dchan->tp.coderateL;
=2D			feparams.u.ofdm.constellation=3Dchan->tp.modulation;
=2D			feparams.u.ofdm.transmission_mode=3Dchan->tp.transmission;
=2D			feparams.u.ofdm.guard_interval=3Dchan->tp.guard;
=2D			feparams.u.ofdm.hierarchy_information=3Dchan->tp.hierarchy;
+			cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_DVBT;
+			cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D freq;
+			cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modul=
ation;
+			cmdargs[3].cmd =3D DTV_CODE_RATE_HP; cmdargs[3].u.data =3D chan->tp.cod=
erateH;
+			cmdargs[4].cmd =3D DTV_CODE_RATE_LP; cmdargs[4].u.data =3D chan->tp.cod=
erateL;
+			cmdargs[5].cmd =3D DTV_GUARD_INTERVAL; cmdargs[5].u.data =3D chan->tp.g=
uard;
+			cmdargs[6].cmd =3D DTV_TRANSMISSION_MODE; cmdargs[6].u.data =3D chan->t=
p.transmission;
+			cmdargs[7].cmd =3D DTV_HIERARCHY; cmdargs[7].u.data =3D chan->tp.hierar=
chy;
+			if ( chan->tp.bandwidth=3D=3DBANDWIDTH_8_MHZ )
+				bandwidth =3D 8000000;
+			else if ( chan->tp.bandwidth=3D=3DBANDWIDTH_7_MHZ )
+				bandwidth =3D 7000000;
+			else if ( chan->tp.bandwidth=3D=3DBANDWIDTH_6_MHZ )
+				bandwidth =3D 6000000;
+			cmdargs[8].cmd =3D DTV_BANDWIDTH_HZ; cmdargs[8].u.data =3D bandwidth;
+			cmdargs[9].cmd =3D DTV_INVERSION; cmdargs[9].u.data =3D inversion;
+			cmdargs[10].cmd =3D DTV_TUNE;
+			cmdseq.num =3D 11;
+			cmdseq.props =3D cmdargs;
 			fprintf(stderr,"tuning DVB-T to %lu Hz\n", freq);
 			fprintf(stderr,"inv:%d bw:%d fecH:%d fecL:%d mod:%d tm:%d gi:%d hier:%d=
\n", chan->tp.inversion,
 				chan->tp.bandwidth, chan->tp.coderateH, chan->tp.coderateL, chan->tp.m=
odulation,
@@ -363,11 +392,16 @@
 			break;
 		}
 		case FE_QAM : {
+			cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_DVBC_=
ANNEX_AC;
+			cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D freq;
+			cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modul=
ation;
+			cmdargs[3].cmd =3D DTV_SYMBOL_RATE; cmdargs[3].u.data =3D srate;
+			cmdargs[4].cmd =3D DTV_INNER_FEC; cmdargs[4].u.data =3D chan->tp.codera=
teH;
+			cmdargs[5].cmd =3D DTV_INVERSION; cmdargs[5].u.data =3D inversion;
+			cmdargs[6].cmd =3D DTV_TUNE;
+			cmdseq.num =3D 7;
+			cmdseq.props =3D cmdargs;
 			fprintf(stderr,"tuning DVB-C to %lu\n", freq);
=2D			feparams.frequency=3Dfreq;
=2D			feparams.u.qam.symbol_rate =3D srate;
=2D			feparams.u.qam.fec_inner =3D chan->tp.coderateH;
=2D			feparams.u.qam.modulation =3D chan->tp.modulation;
 			fprintf(stderr,"inv:%d sr:%lu fecH:%d mod:%d\n", chan->tp.inversion,
 				srate, chan->tp.coderateH, chan->tp.modulation );
 			break;
@@ -395,47 +429,68 @@
 						lof =3D (dvbDevice->lnb[lnbPos].loFreq*1000);
 				}
 				if ( freq<lof )
=2D					feparams.frequency =3D ( lof-freq );
+					freq =3D ( lof-freq );
 				else
=2D					feparams.frequency =3D ( freq-lof );
+					freq =3D ( freq-lof );
 			}
=2D			else
=2D				feparams.frequency=3Dfreq;
=2D
=2D			feparams.u.qpsk.symbol_rate=3Dsrate;
=2D			feparams.u.qpsk.fec_inner=3Dchan->tp.coderateH;
=2D			fprintf(stderr,"inv:%d fecH:%d\n", chan->tp.inversion, chan->tp.coder=
ateH );
+			fprintf(stderr,"inv:%d fecH:%d mod:%d\n", chan->tp.inversion, chan->tp.=
coderateH, chan->tp.modulation );
 			if ( setDiseqc( lnbPos, chan, hiband, rotorMove, dvr )!=3D0 ) {
 				closeFe();
 				return false;
 			}
+			if ( chan->tp.S2 ) {
+				fprintf(stderr,"\nTHIS IS DVB-S2 >>>>>>>>>>>>>>>>>>>\n");
+				cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_DVBS=
2;
+				cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D freq;
+				cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modu=
lation;
+				cmdargs[3].cmd =3D DTV_SYMBOL_RATE; cmdargs[3].u.data =3D srate;
+				cmdargs[4].cmd =3D DTV_INNER_FEC; cmdargs[4].u.data =3D chan->tp.coder=
ateH;
+				cmdargs[5].cmd =3D DTV_PILOT; cmdargs[5].u.data =3D PILOT_AUTO;
+				cmdargs[6].cmd =3D DTV_ROLLOFF; cmdargs[6].u.data =3D chan->tp.rolloff;
+				cmdargs[7].cmd =3D DTV_INVERSION; cmdargs[7].u.data =3D inversion;
+				cmdargs[8].cmd =3D DTV_TUNE;
+				cmdseq.num =3D 9;
+				cmdseq.props =3D cmdargs;
+			}
+			else {
+				cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_DVBS;
+				cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D freq;
+				cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modu=
lation;
+				if ( chan->tp.modulation=3D=3DQAM_AUTO )
+					cmdargs[2].u.data =3D QPSK;
+				cmdargs[3].cmd =3D DTV_SYMBOL_RATE; cmdargs[3].u.data =3D srate;
+				cmdargs[4].cmd =3D DTV_INNER_FEC; cmdargs[4].u.data =3D chan->tp.coder=
ateH;
+				cmdargs[5].cmd =3D DTV_INVERSION; cmdargs[5].u.data =3D inversion;
+				cmdargs[6].cmd =3D DTV_TUNE;
+				cmdseq.num =3D 7;
+				cmdseq.props =3D cmdargs;
+			}
 			break;
 		}
 		case FE_ATSC : {
+			cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_ATSC;
+			cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D freq;
+			cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modul=
ation;
+			cmdargs[3].cmd =3D DTV_INVERSION; cmdargs[3].u.data =3D inversion;
+			cmdargs[4].cmd =3D DTV_TUNE;
+			cmdseq.num =3D 5;
+			cmdseq.props =3D cmdargs;
 			fprintf(stderr,"tuning ATSC to %lu\n", freq);
=2D			feparams.frequency=3Dfreq;
=2D			feparams.u.vsb.modulation =3D chan->tp.modulation;
 			fprintf(stderr,"inv:%d mod:%d\n", chan->tp.inversion, chan->tp.modulati=
on );
 			break;
 		}
 	}
=2D	if ( chan->tp.inversion=3D=3DINVERSION_AUTO ) {
=2D		if ( fe_info.caps & FE_CAN_INVERSION_AUTO )
=2D			feparams.inversion=3Dchan->tp.inversion;
=2D		else {
=2D			fprintf(stderr,"Can NOT inversion_auto\n");
=2D			feparams.inversion=3DINVERSION_OFF;
=2D		}
=2D	}
=2D	else
=2D		feparams.inversion=3Dchan->tp.inversion;
=20
 	if ( rotorMove )
 		loop =3D 2;
=20
+	t2 =3D QTime::currentTime();
+	fprintf( stderr, "Diseqc settings time =3D %d ms\n", t1.msecsTo( t2 ) );
+	t1 =3D t2;
+
 	while ( loop>-1 ) {
=2D		if (ioctl(fdFrontend,FE_SET_FRONTEND,&feparams) < 0) {
=2D			perror("ERROR tuning \n");
+		if ( ioctl( fdFrontend, FE_SET_PROPERTY, &cmdseq )<0 ) {
+			perror("ERROR tuning\n");
 			closeFe();
 			return false;
 		}
@@ -462,6 +517,10 @@
 		return false;
 	}
=20
+	t2 =3D QTime::currentTime();
+	fprintf( stderr, "Tuning time =3D %d ms\n", t1.msecsTo( t2 ) );
+	t1 =3D t2;
+
 	if ( rotorMove )
 		dvbDevice->lnb[lnbPos].currentSource =3D chan->tp.source;
=20
@@ -482,7 +541,7 @@
 }
=20
=20
=2D
+#define DISEQC_X 2
 int DvbStream::setDiseqc( int switchPos, ChannelDesc *chan, int hiband, in=
t &rotor, bool dvr )
 {
 	struct dvb_diseqc_master_cmd switchCmd[] =3D {
@@ -519,7 +578,7 @@
 		perror("FE_SET_VOLTAGE failed");
=20
 	fprintf( stderr, "DiSEqC: %02x %02x %02x %02x %02x %02x\n", switchCmd[ci]=
=2Emsg[0], switchCmd[ci].msg[1], switchCmd[ci].msg[2], switchCmd[ci].msg[3]=
, switchCmd[ci].msg[4], switchCmd[ci].msg[5] );
=2D	for ( i=3D0; i<2; ++i ) {
+	for ( i=3D0; i<DISEQC_X; ++i ) {
 		usleep(15*1000);
 		if ( ioctl(fdFrontend, FE_DISEQC_SEND_MASTER_CMD, &switchCmd[ci]) )
 			perror("FE_DISEQC_SEND_MASTER_CMD failed");
@@ -586,15 +645,17 @@
 		}
 	}
=20
=2D	for ( i=3D0; i<2; ++i ) {
+	for ( i=3D0; i<DISEQC_X; ++i ) {
 		usleep(15*1000);
 		if ( ioctl(fdFrontend, FE_DISEQC_SEND_BURST, (ci/4)%2 ? SEC_MINI_B : SEC=
_MINI_A) )
 			perror("FE_DISEQC_SEND_BURST failed");
 	}
=20
=2D	usleep(15*1000);
=2D	if ( ioctl(fdFrontend, FE_SET_TONE, (ci/2)%2 ? SEC_TONE_ON : SEC_TONE_O=
=46F) )
=2D		perror("FE_SET_TONE failed");
+	if ( (ci/2)%2 ) {
+		usleep(15*1000);
+		if ( ioctl(fdFrontend, FE_SET_TONE, SEC_TONE_ON) )
+			perror("FE_SET_TONE failed");
+	}
=20
 	return 0;
 }
@@ -692,7 +753,7 @@
 	};
=20
 	int i;
=2D	for ( i=3D0; i<2; ++i ) {
+	for ( i=3D0; i<DISEQC_X; ++i ) {
 		usleep(15*1000);
 		if ( ioctl( fdFrontend, FE_DISEQC_SEND_MASTER_CMD, &cmds[cmd] ) )
 			perror("Rotor : FE_DISEQC_SEND_MASTER_CMD failed");
Index: src/input/dvb/dvbpanel.cpp
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/input/dvb/dvbpanel.cpp	(r=C3=A9vision 863489)
+++ src/input/dvb/dvbpanel.cpp	(copie de travail)
@@ -2263,6 +2263,8 @@
 				case 67 : chan->tp.coderateH =3D FEC_6_7; break;
 				case 78 : chan->tp.coderateH =3D FEC_7_8; break;
 				case 89 : chan->tp.coderateH =3D FEC_8_9; break;
+				case 35 : chan->tp.coderateH =3D FEC_3_5; break;
+				case 910 : chan->tp.coderateH =3D FEC_9_10; break;
 				case -1 : chan->tp.coderateH =3D FEC_AUTO;
 			}
 			s =3D s.right( s.length()-pos-1 );
@@ -2283,6 +2285,9 @@
 				case 256 : chan->tp.modulation =3D QAM_256; break;
 				case 108 : chan->tp.modulation =3D VSB_8; break;
 				case 116 : chan->tp.modulation =3D VSB_16; break;
+				case 1000 : chan->tp.modulation =3D PSK_8; break;
+				case 1001 : chan->tp.modulation =3D APSK_16; break;
+				case 1003 : chan->tp.modulation =3D DQPSK; break;
 				case -1 : chan->tp.modulation =3D QAM_AUTO;
 			}
 			s =3D s.right( s.length()-pos-1 );
@@ -2297,6 +2302,8 @@
 				case 67 : chan->tp.coderateL =3D FEC_6_7; break;
 				case 78 : chan->tp.coderateL =3D FEC_7_8; break;
 				case 89 : chan->tp.coderateL =3D FEC_8_9; break;
+				case 35 : chan->tp.coderateH =3D FEC_3_5; break;
+				case 910 : chan->tp.coderateH =3D FEC_9_10; break;
 				case -1 : chan->tp.coderateL =3D FEC_AUTO;
 			}
 			s =3D s.right( s.length()-pos-1 );
@@ -2364,6 +2371,17 @@
 			s =3D s.right( s.length()-pos-1 );
 			pos =3D s.find("|");
 			chan->tp.nid =3D s.left(pos).toUShort();
+			s =3D s.right( s.length()-pos-1 );
+			pos =3D s.find("|");
+			switch ( s.left(pos).toInt() ) {
+				case 20 : chan->tp.rolloff =3D ROLLOFF_20; break;
+				case 25 : chan->tp.rolloff =3D ROLLOFF_25; break;
+				case 35 : chan->tp.rolloff =3D ROLLOFF_35; break;
+				case -1 : chan->tp.rolloff =3D ROLLOFF_AUTO;
+			}
+			s =3D s.right( s.length()-pos-1 );
+			pos =3D s.find("|");
+			chan->tp.S2 =3D s.left(pos).toInt();
=20
 			if ( chan->tp.source.isEmpty() ) {
 				delete chan;
@@ -2475,6 +2493,8 @@
 				case FEC_6_7 : tt<< "67|"; break;
 				case FEC_7_8 : tt<< "78|"; break;
 				case FEC_8_9 : tt<< "89|"; break;
+				case FEC_3_5 : tt<< "35|"; break;
+				case FEC_9_10 : tt<< "910|"; break;
 				case FEC_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.inversion ) {
@@ -2491,6 +2511,9 @@
 				case QAM_256 : tt<< "256|"; break;
 				case VSB_8 : tt<< "108|"; break;
 				case VSB_16 : tt<< "116|"; break;
+				case PSK_8 : tt<< "1000|"; break;
+				case APSK_16 : tt<< "1001|"; break;
+				case DQPSK : tt<< "1003|"; break;
 				case QAM_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.coderateL ) {
@@ -2503,6 +2526,8 @@
 				case FEC_6_7 : tt<< "67|"; break;
 				case FEC_7_8 : tt<< "78|"; break;
 				case FEC_8_9 : tt<< "89|"; break;
+				case FEC_3_5 : tt<< "35|"; break;
+				case FEC_9_10 : tt<< "910|"; break;
 				case FEC_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.bandwidth ) {
@@ -2541,7 +2566,15 @@
 			}
 			tt<< "|";
 			tt<< chan->category+"|";
=2D			tt<< s.setNum(chan->tp.nid)+"|\n";
+			tt<< s.setNum(chan->tp.nid)+"|";
+			switch ( chan->tp.rolloff ) {
+				case ROLLOFF_20 : tt<< "20|"; break;
+				case ROLLOFF_25 : tt<< "25|"; break;
+				case ROLLOFF_35 : tt<< "35|"; break;
+				case ROLLOFF_AUTO : tt<< "-1|";
+			}
+			tt<< s.setNum(chan->tp.S2)+"|";
+			tt<< "\n";
 		}
 		ret =3D true;
 		f.close();

--Boundary-00=_aLj+IqO05s+/nIU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_aLj+IqO05s+/nIU--
