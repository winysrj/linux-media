Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KhiEz-0002YM-05
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 12:02:04 +0200
From: Christophe Thommeret <hftom@free.fr>
To: "Hans Werner" <HWerner4@gmx.de>
Date: Mon, 22 Sep 2008 12:01:25 +0200
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
In-Reply-To: <20080921235429.18440@gmx.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2z21IPjdJ7V1nYJ"
Message-Id: <200809221201.26115.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

--Boundary-00=_2z21IPjdJ7V1nYJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Monday 22 September 2008 01:54:29 Hans Werner, vous avez =E9crit=A0:
> -------- Original-Nachricht --------
>
> > Datum: Sun, 21 Sep 2008 19:05:34 +0200
> > Von: Christophe Thommeret <hftom@free.fr>
> > An: Steven Toth <stoth@linuxtv.org>, "linux-dvb" <linux-dvb@linuxtv.org>
> > Betreff: [linux-dvb] hvr4000-s2api + QAM_AUTO
> >
> > Hi Steve,
> >
> > I've managed to add S2 support to kaffeine, so it can scan and zap.
> > However, i have a little problem with DVB-S:
> > Before tuning to S2, S channels tune well with QAM_AUTO.
> > But after having tuned to S2 channels, i can no more lock on S ones unt=
il
> > i
> > set modulation to QPSK insteed of QAM_AUTO for these S channels.
> > Is this known?
> >
> > --
> > Christophe Thommeret
>
> Hi Christophe,
> do you mean FEC_AUTO? There is a note in the comments in cx24116.c about
> FEC_AUTO working for QPSK but not for S2 (8PSK or NBC-QPSK).
> Look for "Especially, no auto detect when in S2 mode."

Good to know, but i really mean QAM_AUTO

> I'd be very happy to try out your patch for Kaffeine and give feedback if
> you are ready to share it.

Sure, here it is (patch against current svn=20
http://websvn.kde.org/branches/extragear/kde3/multimedia/)

Atm, s2api is only used for S/S2.

P.S.
In order to play H264/HD with kaffeine/xine, you need a fairly recent ffmpe=
g=20
and xine compiled with --with-external-ffmpeg configure option. (and of=20
course a quite strong cpu, unlike my old athlon-xp-2600 :)
However, you can still record and/or broadcast without this update.

=2D-=20
Christophe Thommeret

--Boundary-00=_2z21IPjdJ7V1nYJ
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="kaffeine-s2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kaffeine-s2.patch"

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
+		channel->tp.rolloff =3D (fe_rolloff_t)(ROLLOFF_20+rolloffComb->currentIt=
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
+	rolloffComb->setCurrentItem( ROLLOFF_20+channel->tp.rolloff );
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
<"VSB-8"<<"VSB-16"<<"8PSK"<<"16APSK"<<"NBC-QPSK"<<"DQPSK";
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
+	list<<"20"<<"25"<<"35"<<"AUTO";
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
@@ -226,22 +229,61 @@
 		trans->pol =3D 'v';
 	else
 		trans->pol =3D 'h';
+	switch ( getBits(buf,70,2) ) {
+		case 0 : trans->modulation =3D QAM_AUTO; break;
+		case 1 : trans->modulation =3D QPSK; break;
+		case 2 : trans->modulation =3D _8PSK; break;
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
+		fprintf(stderr,"\n\n!!!!!!!!!!!!!!!!!! Found S2 MODULATION SYSTEM !!!!!!=
!!!!!!!!!!!!!!!!!!!!!!!!\n\n");
+		trans->S2 =3D 1;
+		if ( trans->modulation=3D=3DQPSK )
+			trans->modulation =3D NBC_QPSK; //until we find a S2 descriptor, assume=
 NBC.
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
+	fprintf(stderr,"\n\n!!!!!!!!!!!!!!!!!! Found S2 DESCRIPTOR !!!!!!!!!!!!!!=
!!!!!!!!!!!!!!!!\n\n");
+	int scrambling_sequence_selector =3D getBits(buf,16,1);
+	int multiple_input_stream_flag =3D getBits(buf,17,1);
+	int backwards_compatibility_indicator =3D getBits(buf,18,1);
+	if ( backwards_compatibility_indicator && trans->modulation=3D=3DNBC_QPSK=
 ) /*FIXME*/ // not sure of this
+		trans->modulation =3D QPSK;
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
@@ -261,13 +303,17 @@
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
+	fdFrontend =3D open( frontendName.ascii(), O_RDWR | O_NONBLOCK );
 	if ( fdFrontend<0 ) {
 		perror("openFe:");
 		fdFrontend =3D 0;
@@ -328,6 +328,9 @@
 	int rotorMove =3D 0;
 	int loop=3D0, i;
=20
+	struct dtv_property cmdargs[20];
+	struct dtv_properties cmdseq;
+
 	closeFe();
 	if ( !openFe() )
 		return false;
@@ -344,6 +347,9 @@
 	freq*=3D1000;
 	srate*=3D1000;
=20
+	QTime t1 =3D QTime::currentTime();
+	QTime t2;
+
 	switch( fe_info.type ) {
 		case FE_OFDM : {
 			if (freq < 1000000)
@@ -404,11 +410,38 @@
=20
 			feparams.u.qpsk.symbol_rate=3Dsrate;
 			feparams.u.qpsk.fec_inner=3Dchan->tp.coderateH;
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
+				cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D feparams.frequ=
ency;
+				cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modu=
lation;
+				cmdargs[3].cmd =3D DTV_SYMBOL_RATE; cmdargs[3].u.data =3D srate;
+				cmdargs[4].cmd =3D DTV_INNER_FEC; cmdargs[4].u.data =3D chan->tp.coder=
ateH;
+				cmdargs[5].cmd =3D DTV_PILOT; cmdargs[5].u.data =3D PILOT_AUTO;
+				cmdargs[6].cmd =3D DTV_ROLLOFF; cmdargs[6].u.data =3D chan->tp.rolloff;
+				cmdargs[7].cmd =3D DTV_INVERSION; cmdargs[7].u.data =3D INVERSION_AUTO;
+				cmdargs[8].cmd =3D DTV_TUNE;
+				cmdseq.num =3D 9;
+				cmdseq.props =3D cmdargs;
+			}
+			else {
+				cmdargs[0].cmd =3D DTV_DELIVERY_SYSTEM; cmdargs[0].u.data =3D SYS_DVBS;
+				cmdargs[1].cmd =3D DTV_FREQUENCY; cmdargs[1].u.data =3D feparams.frequ=
ency;
+				cmdargs[2].cmd =3D DTV_MODULATION; cmdargs[2].u.data =3D chan->tp.modu=
lation;
+				//if ( chan->tp.modulation=3D=3DQAM_AUTO )
+				//	cmdargs[2].u.data =3D QPSK;
+				cmdargs[3].cmd =3D DTV_SYMBOL_RATE; cmdargs[3].u.data =3D srate;
+				cmdargs[4].cmd =3D DTV_INNER_FEC; cmdargs[4].u.data =3D chan->tp.coder=
ateH;
+				cmdargs[5].cmd =3D DTV_INVERSION; cmdargs[5].u.data =3D INVERSION_AUTO;
+				cmdargs[6].cmd =3D DTV_TUNE;
+				cmdseq.num =3D 7;
+				cmdseq.props =3D cmdargs;
+			}
 			break;
 		}
 		case FE_ATSC : {
@@ -433,9 +466,20 @@
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
+		if ( /*chan->tp.S2*/ fe_info.type=3D=3DFE_QPSK ) {
+			if ( ioctl( fdFrontend, FE_SET_PROPERTY, &cmdseq )<0 ) {
+				perror("ERROR tuning\n");
+				closeFe();
+				return false;
+			}
+		}
+		else if (ioctl(fdFrontend,FE_SET_FRONTEND,&feparams) < 0) {
+			perror("ERROR tuning\n");
 			closeFe();
 			return false;
 		}
@@ -462,6 +506,10 @@
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
@@ -482,7 +530,7 @@
 }
=20
=20
=2D
+#define DISEQC_X 2
 int DvbStream::setDiseqc( int switchPos, ChannelDesc *chan, int hiband, in=
t &rotor, bool dvr )
 {
 	struct dvb_diseqc_master_cmd switchCmd[] =3D {
@@ -519,7 +567,7 @@
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
@@ -586,15 +634,17 @@
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
@@ -692,7 +742,7 @@
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
@@ -2283,6 +2285,10 @@
 				case 256 : chan->tp.modulation =3D QAM_256; break;
 				case 108 : chan->tp.modulation =3D VSB_8; break;
 				case 116 : chan->tp.modulation =3D VSB_16; break;
+				case 1000 : chan->tp.modulation =3D _8PSK; break;
+				case 1001 : chan->tp.modulation =3D _16APSK; break;
+				case 1002 : chan->tp.modulation =3D NBC_QPSK; break;
+				case 1003 : chan->tp.modulation =3D DQPSK; break;
 				case -1 : chan->tp.modulation =3D QAM_AUTO;
 			}
 			s =3D s.right( s.length()-pos-1 );
@@ -2297,6 +2303,8 @@
 				case 67 : chan->tp.coderateL =3D FEC_6_7; break;
 				case 78 : chan->tp.coderateL =3D FEC_7_8; break;
 				case 89 : chan->tp.coderateL =3D FEC_8_9; break;
+				case 35 : chan->tp.coderateH =3D FEC_3_5; break;
+				case 910 : chan->tp.coderateH =3D FEC_9_10; break;
 				case -1 : chan->tp.coderateL =3D FEC_AUTO;
 			}
 			s =3D s.right( s.length()-pos-1 );
@@ -2364,6 +2372,17 @@
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
@@ -2475,6 +2494,8 @@
 				case FEC_6_7 : tt<< "67|"; break;
 				case FEC_7_8 : tt<< "78|"; break;
 				case FEC_8_9 : tt<< "89|"; break;
+				case FEC_3_5 : tt<< "35|"; break;
+				case FEC_9_10 : tt<< "910|"; break;
 				case FEC_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.inversion ) {
@@ -2491,6 +2512,10 @@
 				case QAM_256 : tt<< "256|"; break;
 				case VSB_8 : tt<< "108|"; break;
 				case VSB_16 : tt<< "116|"; break;
+				case _8PSK : tt<< "1000|"; break;
+				case _16APSK : tt<< "1001|"; break;
+				case NBC_QPSK : tt<< "1002|"; break;
+				case DQPSK : tt<< "1003|"; break;
 				case QAM_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.coderateL ) {
@@ -2503,6 +2528,8 @@
 				case FEC_6_7 : tt<< "67|"; break;
 				case FEC_7_8 : tt<< "78|"; break;
 				case FEC_8_9 : tt<< "89|"; break;
+				case FEC_3_5 : tt<< "35|"; break;
+				case FEC_9_10 : tt<< "910|"; break;
 				case FEC_AUTO : tt<< "-1|";
 			}
 			switch ( chan->tp.bandwidth ) {
@@ -2541,7 +2568,15 @@
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

--Boundary-00=_2z21IPjdJ7V1nYJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_2z21IPjdJ7V1nYJ--
